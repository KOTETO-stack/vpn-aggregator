#!/bin/bash
set -e

OUTPUT_DIR="output"
OUTPUT_FILE="$OUTPUT_DIR/vpn-configs.txt"
TIMESTAMP=$(date -u +"%Y%m%d_%H%M")
TS_FILE="$OUTPUT_DIR/vpn-configs-$TIMESTAMP.txt"

SOURCES=(
    "https://raw.githubusercontent.com/aiboboxx/v2rayfree/main/README.md"
    "https://raw.githubusercontent.com/Pawdroid/Free-servers/main/sub"
    "https://raw.githubusercontent.com/mahdibland/ShadowsocksAggregator/master/sub/sub_merge.txt"
    "https://raw.githubusercontent.com/Flik6/get-v2ray/main/v2"
    "https://raw.githubusercontent.com/tbbatbb/Proxy/master/dist/socks5.txt"
    "https://raw.githubusercontent.com/ripaojiedian/freenode/main/sub"
    "https://raw.githubusercontent.com/learnhard-cn/free_proxy_ss/main/ssr"
    "https://raw.githubusercontent.com/yaney01/Yaney01/main/README.md"
    "https://raw.githubusercontent.com/v2raydy/v2ray/main/README.md"
    "https://raw.githubusercontent.com/w1770946466/Auto_proxy/main/Long_term_subscription1"
    "https://raw.githubusercontent.com/Leon406/SubCrawler/main/sub/share/all3"
    "https://raw.githubusercontent.com/anaer/Sub/main/clash.yaml"
    "https://raw.githubusercontent.com/mermeroo/Clash-V2ray/main/README.md"
    "https://raw.githubusercontent.com/ermaozi/get_subscribe/main/subscribe/v2ray.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/All_Configs_Sub.txt"
    "https://raw.githubusercontent.com/hkaa0/permalink/main/proxy/V2RAY.txt"
    "https://raw.githubusercontent.com/peasoft/NoMoreWalls/master/list.txt"
    "https://raw.githubusercontent.com/itsyebekhe/HiN-VPN/main/Subscription.txt"
    "https://raw.githubusercontent.com/ermaozi01/free_clash_vpn/main/subscribe/v2ray.txt"
    "https://raw.githubusercontent.com/a2470982985/getNode/main/v2ray.txt"
    "https://raw.githubusercontent.com/OoMeGaOo/v2ray/master/README.md"
    "https://raw.githubusercontent.com/adiwzx/freenode/main/README.md"
    "https://raw.githubusercontent.com/moneyfly1/sublist/main/README.md"
    "https://raw.githubusercontent.com/pojiezhiyuanjun/freev2/master/README.md"
    "https://raw.githubusercontent.com/zyfxz/V2Ray/main/README.md"
    "https://raw.githubusercontent.com/ssrsub/ssr/master/README.md"
    "https://raw.githubusercontent.com/freefq/free/master/v2"
    "https://raw.githubusercontent.com/2dust/v2RayNG/master/"
    "https://raw.githubusercontent.com/mianfeifq/share/main/"
)

mkdir -p "$OUTPUT_DIR"

echo "========================================"
echo "VPN Aggregator (Bash) v2.0"
echo "Started: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
echo "========================================"

TMP_FILE=$(mktemp)
echo "[1/3] Collecting configs from ${#SOURCES[@]} sources..."

for src in "${SOURCES[@]}"; do
    echo "  Fetching: $src"
    curl -sL --max-time 15 "$src" >> "$TMP_FILE" 2>/dev/null || true
done

echo "[2/3] Extracting VPN links..."
VLESS=$(grep -oE 'vless://[^[:space:]]+' "$TMP_FILE" | sort -u || true)
VMESS=$(grep -oE 'vmess://[^[:space:]]+' "$TMP_FILE" | sort -u || true)
TROJAN=$(grep -oE 'trojan://[^[:space:]]+' "$TMP_FILE" | sort -u || true)
HY2=$(grep -oE 'hysteria2://[^[:space:]]+' "$TMP_FILE" | sort -u || true)
HY2_ALT=$(grep -oE 'hy2://[^[:space:]]+' "$TMP_FILE" | sort -u || true)

ALL_CONFIGS=$(echo "$VLESS" && echo "$VMESS" && echo "$TROJAN" && echo "$HY2" && echo "$HY2_ALT" | grep -v '^$' | sort -u)
TOTAL=$(echo "$ALL_CONFIGS" | wc -l)
echo "Total unique configs: $TOTAL"

echo "[3/3] Filtering..."
FILTERED=$(echo "$ALL_CONFIGS" | grep -vi 'ukraine\|украина' || true)
FILTERED_COUNT=$(echo "$FILTERED" | grep -v '^$' | wc -l)
echo "After filter: $FILTERED_COUNT"

TOP20=$(echo "$FILTERED" | head -n 20)

WARP1="warp://engage.cloudflareclient.com:2408?pk=bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=&ifp=5-10#WARP+_PROTECTION_1"
WARP2="warp://162.159.192.1:2408?pk=bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=&ifp=5-10#WARP+_PROTECTION_2"

AMNEZIA="vpn://AAAA_3icXY3LDoIwEEV_hXStJhhjojsjERN0AbowbkgtAzZA2_QBQcO_2xbduJrMPXfmvBHDLaBtgHYtgxfFwUECoFmAClBEUqEpZ_84IJwxIB7Zpt1KWuUdSDWVlzbEguYTsMEbKZAdJZDrQXgbnt7Ny6_tx4XkmhPe-E5fOWQss68M03Kws_D30qDRWYx-5gXW2Eucs4bB8Yg2qyTM-sUjO16u9SmKUxOt92VI6js_dzyNsz7cqOSGxvEDmaFXJg==#Amnezia-Free-Primary"

cat > "$OUTPUT_FILE" << 'HEADER'
# VPN Configs for Karing
# Generated: auto
# Protocols: VLESS, Vmess, Hysteria2, Trojan
# Protection: WARP+ (primary), Amnezia (secondary)
# Update: every hour
# Servers: 20 best + 2 WARP+ + 1 Amnezia

## === WARP+ PROTECTION (Primary) ===
HEADER

echo "$WARP1" >> "$OUTPUT_FILE"
echo "$WARP2" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'FAST'
## === FAST SERVERS (Top 20) ===
FAST

echo "$TOP20" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << 'AMN'
## === AMNEZIA PROTECTION (Secondary) ===
AMN

echo "$AMNEZIA" >> "$OUTPUT_FILE"

cp "$OUTPUT_FILE" "$TS_FILE"

LINES=$(wc -l < "$OUTPUT_FILE")
echo ""
echo "========================================"
echo "SUCCESS!"
echo "  Output: $OUTPUT_FILE"
echo "  Lines: $LINES"
echo "========================================"

rm -f "$TMP_FILE"
