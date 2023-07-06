Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B342749389
	for <lists+io-uring@lfdr.de>; Thu,  6 Jul 2023 04:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjGFCLa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 22:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjGFCL3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 22:11:29 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2127.outbound.protection.outlook.com [40.107.255.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6CC19A9;
        Wed,  5 Jul 2023 19:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqyDwqrJDcpO5AaCSOlkBWDQbbIPNpxs3im2cIZKDeB4ZYKgzi6pPEM4OJSv/LinCUs8aPXJlAcBHH22I0lZBN0ImHkRu9YI8WSG9cQNNck/xlYFCq6MUJzVkI+3XpdJkrkkDMe8aPvnPrCxjZpCB1QMWuPnv+2fBaXBOE8Mxh0FL43m+OdCaC3d1/u3/KV/TAQ99FYWWYA7N4hUlo8n/SCdj6st4X1S2lTrjbYBlf5F6hk2dmSCbWHRBUbp0p3TybgRuPukvFo9f9U1qWBWvVUj0DSsojxeJmBGF60FAYxAGSuVDP9OUjFjfRiCOtgN/cu1WTf4l1oT9bcZ8wLXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ugY+1ShlS7IIZZCnoXdEsWUabJWbbkhTdKnJL8m15c=;
 b=OJ8KBxvMceNIaQszYil5561rmue0YqEr6Q0wQxocBCdio2HinpMY0/7qX1A2qMvIEGya72KzNewrNzOu38Dax5Kv5FZrDzWeiGK8yeWgVagdncQzAbL0vlTecun1Uvzu1nA2+RIJ6mpQ2fRF664r9wn8qm5TW2LEtmUpdo0jQNpYrc+WGtGwLtEtw9/T5MbilYsUbeTfc78zg/xWbLkTwh3bnG68c4uIjgUt36mGiE71QVCE47W8n5ZUtb3px5YkVXgk8vCFX/2+vaGTsLwpYJY4e/1LwEiloUPDLX77124cSYLzLDKwW5kDdQXmluvQIZFTZbL3oKBzkg2bt3pLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ugY+1ShlS7IIZZCnoXdEsWUabJWbbkhTdKnJL8m15c=;
 b=FCsCO8RVzaJtXdkGzix83nnuP4AvSBPhVJsvN/cq+fdD7qet47XH9TFRA3wh5WBe51uhIniuSX13mh0wNiwAN8NCw33vnQZHuUzXT4q7+YM4/EX9ZqnK4TJy+3KTGZnfIL/p+/qrnyWGN1RRD5yZarvvOAJJmxJYRefXp/pj5sbmpL8isrQqNPx7Y3tOuo/0/RKmmn6X9wWX8UWJuUqiJH4nvytAQyoXn3JnzdUjcygeRe6CEI6mjdwfTFXdaURVGoD0Pv5Kg53718TlciEOFHabqW/zrXGYt+mQWJ9Iz2Q8aXhWp1ibWCzQ3KHltXCPLR/zAlTUnpnphxlMXEoigg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6615.apcprd06.prod.outlook.com (2603:1096:101:172::11)
 by SEZPR06MB6206.apcprd06.prod.outlook.com (2603:1096:101:e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Thu, 6 Jul
 2023 02:11:24 +0000
Received: from SEYPR06MB6615.apcprd06.prod.outlook.com
 ([fe80::c817:d237:dc0d:576]) by SEYPR06MB6615.apcprd06.prod.outlook.com
 ([fe80::c817:d237:dc0d:576%4]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 02:11:24 +0000
From:   Yang Rong <yangrong@vivo.com>
To:     Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alvin Lee <Alvin.Lee2@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Max Tseng <Max.Tseng@amd.com>,
        Josip Pavic <Josip.Pavic@amd.com>,
        Cruise Hung <cruise.hung@amd.com>,
        amd-gfx@lists.freedesktop.org (open list:AMD DISPLAY CORE),
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        io-uring@vger.kernel.org (open list:IO_URING)
Cc:     opensource.kernel@vivo.com, luhongfei@vivo.com,
        Yang Rong <yangrong@vivo.com>
Subject: [PATCH] Fix max/min warnings in virtio_net, amd/display, and io_uring
Date:   Thu,  6 Jul 2023 10:06:16 +0800
Message-ID: <20230706021102.2066-1-yangrong@vivo.com>
X-Mailer: git-send-email 2.41.0.windows.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TYWPR01CA0021.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::8) To SEYPR06MB6615.apcprd06.prod.outlook.com
 (2603:1096:101:172::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6615:EE_|SEZPR06MB6206:EE_
X-MS-Office365-Filtering-Correlation-Id: 0665b1c4-1ffd-4c98-ffd7-08db7dc64be3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9h/oybtn2Ol+7Afg+l2R70jkdGdhTrOmwcUg/Pyf+2hmB0lH/VB4ff/AHFCRwRKOypVC4beBOUr8BMTZGB1H2y8d8qQfFhWoVZekrXeI6OtZGkG748KUYtNicKuUS22gbrIeU5CIB1meeA4McOx8urqbnY1SvtCoo8AYPMuV4si0Z/XlId1OET/WnPZ+tNX9ikI/+BMkmYtge5qXKQJDaJuP3n1XUIfAINQsgrlTkxO75LqAxZgAVM9rpvV9N11ssd7ul2BNQ/FzGLChk0mENozAtgx1elD0oNKvNNPiVMYqGh+k4wi7k+Zw3xltAZM1dlP0wvfwzgbhXJ7CbNMrblZvmFd49F+I06InV151OLT6DUuTLRudKZbYhSFtjTtBYNDFKzKl8Zh/sTTZ08DQmC4Fr+e9W2Iot7M5j7T+rccva8XYMeuDgu9QIEMbjg9dGX1TTqbt6/WsgLVIt9vu9/yU0y86PPWwIjz1RUq7FOiNwJWSljiooYkX9zNs6qwMf2uXOj4Anw7SR3+aiGFj7qRnTaVn7Q4NTc6bdtQWZG5X1q3z/LzbPXvqjjTBTkmfty8HUCtw6NEN8CiXmSZO1d8O6XmfD6K7UqaCMwC6rKk93C1L14mh7FaV3QuQ6ZOGwP2zR0h7WX7v9nupFXtEqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6615.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199021)(110136005)(921005)(6486002)(52116002)(6666004)(478600001)(41300700001)(8936002)(8676002)(38100700002)(38350700002)(2616005)(4326008)(66556008)(66476007)(316002)(66946007)(186003)(83380400001)(6512007)(107886003)(26005)(1076003)(6506007)(86362001)(5660300002)(7416002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xThDpyZ962z9nuD5jE8UpZfDeGujqMBlH9gr+d3+F9bgOytALtIh5DwMpdP3?=
 =?us-ascii?Q?QwZJQ75hMZNZxZ4IVQlXHzvyHfyXJNXGry3I/0BYsnz7rz9+o02Blh11CBc2?=
 =?us-ascii?Q?FPyvt4PRrV03GxTVKAlyFv70JDdgBavfHyvgPvqCEUy37UzelH7CdzHkJuEq?=
 =?us-ascii?Q?5P3Utd9Kt01n5k4tK8mcOQJbeY610uKvj7UOXPLOXQSMWPwETblN2FUbahSp?=
 =?us-ascii?Q?LL8spaUiZpepkCg+lWSPV3AtJ3nYrdSY/t3nDnXEBFUBfn/VaW/yT9o++hFX?=
 =?us-ascii?Q?iOFS2Oa9XSjHiyX2r9KHeKSBDFaVdqtWUl7+WgfECxTb/YK7ymHupwshGzTL?=
 =?us-ascii?Q?OpW45BpucGkbC43cCkQwQY2SkLpdcIKHuNGq+u+prnXTojXQSHgPfTxIyr+K?=
 =?us-ascii?Q?Y78EALA2bVNA7tZuCfub86g8Vt5ssCZUY/RD3b8MtnHDG53SGeMaER46Pump?=
 =?us-ascii?Q?kHHQw5Tv3ghBHpLTbWaRbo47pQLs3IlNsWeaaT4CVbCDtlSPBJgb9Baa9TEz?=
 =?us-ascii?Q?+sBBGITuKLIg/Htg/ShfIsh98BVZLqoiG8wXHERxNMBTWE6TINXquw6usFLx?=
 =?us-ascii?Q?QHHKtCwpttSA6vap69uBhSPCN0MqvlvSpRg7NEhOMS1HboVQIvRAjczkG0I2?=
 =?us-ascii?Q?JgovUP0KfJYratEwsWZDkiOsy28eTlO58af32JktwA4fvyKkPS2G7Rm3L0Fm?=
 =?us-ascii?Q?0CvifsRzawl14ThcQsQSdvUCfxSy5+dC+0ctI3GmukSdcoNFf08E+N/kMoC0?=
 =?us-ascii?Q?iS6absxos4Ve6W8a8qYfwhlvt69sdWq/BtQV6SQLOOOF3UXlg6echoKvzVGi?=
 =?us-ascii?Q?Q+FtxFQ9OGF5K13XEwDemVmz5VFYdrwY/srVzjbhs+3Thc/Bk9lh/UUNRaAm?=
 =?us-ascii?Q?PWg2KLY95152V8iutmb9rC6iKe8nzN9Uf2gYnMJl0p6tE3u3H8QguscUNh2N?=
 =?us-ascii?Q?zd1z3CyS7UimSF99SeRyQ0sz7BW3RiCp20/v9N+0CTUc63vC2hMqtaMpz2W5?=
 =?us-ascii?Q?CZGMPhtBrXl6XKEj0vipbUB7STtsJDsgSE+XRVZph18jVcbP+XK/TK+Ky5NW?=
 =?us-ascii?Q?faa4B5qzMlGV4yzn9EJDxZgoRT0RNwKiti9QeXl+o+unbN0wOybM+2J2KSG8?=
 =?us-ascii?Q?lD/+5TI3wrNB7107G7rWhSYP55AaFdBcgW6r87Rb7jgsPELhjfCz12APns8W?=
 =?us-ascii?Q?DXeFxQIt4c9lYkYrsEN1rGzraMokPefvqBUfNCJ4N6UOPDGgVjr6Jy+50pvL?=
 =?us-ascii?Q?4pfH3HF/M7aTvkStud0VOh+s3m7suZ1/nij+tHuKvnB+vFm88Ea9+SorSPbU?=
 =?us-ascii?Q?ugKBSrwOTWPQXaeaLaG6s4tMiTkTQYt5TjADTMPGugm3dIwFcvUg1RS45QGH?=
 =?us-ascii?Q?9kBIWHwxjdSCVtaS0g9WTjIx4NEuhrmLCc1CBouuGHMejP0gpz4CW5DJ1Ze0?=
 =?us-ascii?Q?5Xw0CZEfCGIHa/C87g4IZVs16dyZuhNxqvv8+Gp10im5Se6r86kMX6ro7xY9?=
 =?us-ascii?Q?/fb/bxa296mJM0ftUmUIgjOoPmIvuaR1KWLPWvGAyOT0/v8hZOE6i9/gj+F9?=
 =?us-ascii?Q?wPCWUaxa7+/0E+z1CsJklibbfaFF6OMsH3/Iv2GY?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0665b1c4-1ffd-4c98-ffd7-08db7dc64be3
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6615.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 02:11:23.7184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 60ruQpxSbu1kpyIyypa5KYoL9pBgwWl8keuWbdOtE66ykcEqGnufZHlrr1yY4R/hYyHB4ymcM0zidWvjEz6Yuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB6206
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The files drivers/net/virtio_net.c, drivers/gpu/drm/amd/display/dc/dc_dmub_=
srv.c, and io_uring/io_uring.c were modified to fix warnings.
Specifically, the opportunities for max() and min() were utilized to addres=
s the warnings.

Signed-off-by: Yang Rong <yangrong@vivo.com>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 6 +++---
 drivers/net/virtio_net.c                     | 3 ++-
 io_uring/io_uring.c                          | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm=
/amd/display/dc/dc_dmub_srv.c
index c753c6f30dd7..df79aea49a3c 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -22,7 +22,7 @@
  * Authors: AMD
  *
  */
-
+#include <linux/minmax.h>
 #include "dc.h"
 #include "dc_dmub_srv.h"
 #include "../dmub/dmub_srv.h"
@@ -481,7 +481,7 @@ static void populate_subvp_cmd_drr_info(struct dc *dc,
        max_drr_vblank_us =3D div64_u64((subvp_active_us - prefetch_us -
                        dc->caps.subvp_fw_processing_delay_us - drr_active_=
us), 2) + drr_active_us;
        max_drr_mallregion_us =3D subvp_active_us - prefetch_us - mall_regi=
on_us - dc->caps.subvp_fw_processing_delay_us;
-       max_drr_supported_us =3D max_drr_vblank_us > max_drr_mallregion_us =
? max_drr_vblank_us : max_drr_mallregion_us;
+       max_drr_supported_us =3D max(max_drr_vblank_us, max_drr_mallregion_=
us);
        max_vtotal_supported =3D div64_u64(((uint64_t)drr_timing->pix_clk_1=
00hz * 100 * max_drr_supported_us),
                        (((uint64_t)drr_timing->h_total * 1000000)));

@@ -771,7 +771,7 @@ void dc_dmub_setup_subvp_dmub_command(struct dc *dc,
                wm_val_refclk =3D context->bw_ctx.bw.dcn.watermarks.a.cstat=
e_pstate.pstate_change_ns *
                                (dc->res_pool->ref_clocks.dchub_ref_clock_i=
nKhz / 1000) / 1000;

-               cmd.fw_assisted_mclk_switch_v2.config_data.watermark_a_cach=
e =3D wm_val_refclk < 0xFFFF ? wm_val_refclk : 0xFFFF;
+               cmd.fw_assisted_mclk_switch_v2.config_data.watermark_a_cach=
e =3D min(wm_val_refclk, 0xFFFF);
        }

        dm_execute_dmub_cmd(dc->ctx, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9b3721424e71..5bb7da885f00 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -22,6 +22,7 @@
 #include <net/route.h>
 #include <net/xdp.h>
 #include <net/net_failover.h>
+#include <linux/minmax.h>

 static int napi_weight =3D NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
@@ -1291,7 +1292,7 @@ static struct sk_buff *build_skb_from_xdp_buff(struct=
 net_device *dev,
        __skb_put(skb, data_len);

        metasize =3D xdp->data - xdp->data_meta;
-       metasize =3D metasize > 0 ? metasize : 0;
+       metasize =3D max(metasize, 0);
        if (metasize)
                skb_metadata_set(skb, metasize);

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..875ca657227d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -47,6 +47,7 @@
 #include <linux/refcount.h>
 #include <linux/uio.h>
 #include <linux/bits.h>
+#include <linux/minmax.h>

 #include <linux/sched/signal.h>
 #include <linux/fs.h>
@@ -2660,7 +2661,7 @@ static void *__io_uaddr_map(struct page ***pages, uns=
igned short *npages,
                                        page_array);
        if (ret !=3D nr_pages) {
 err:
-               io_pages_free(&page_array, ret > 0 ? ret : 0);
+               io_pages_free(&page_array, max(ret, 0));
                return ret < 0 ? ERR_PTR(ret) : ERR_PTR(-EFAULT);
        }
        /*
--
2.35.3


________________________________
=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=86=85=E5=
=AE=B9=E5=8F=AF=E8=83=BD=E5=90=AB=E6=9C=89=E6=9C=BA=E5=AF=86=E5=92=8C/=E6=
=88=96=E9=9A=90=E7=A7=81=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E4=BE=9B=E6=8C=
=87=E5=AE=9A=E4=B8=AA=E4=BA=BA=E6=88=96=E6=9C=BA=E6=9E=84=E4=BD=BF=E7=94=A8=
=E3=80=82=E8=8B=A5=E6=82=A8=E9=9D=9E=E5=8F=91=E4=BB=B6=E4=BA=BA=E6=8C=87=E5=
=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E6=88=96=E5=85=B6=E4=BB=A3=E7=90=86=E4=BA=
=BA=EF=BC=8C=E8=AF=B7=E5=8B=BF=E4=BD=BF=E7=94=A8=E3=80=81=E4=BC=A0=E6=92=AD=
=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=96=E5=AD=98=E5=82=A8=E6=AD=A4=E9=82=AE=E4=
=BB=B6=E4=B9=8B=E4=BB=BB=E4=BD=95=E5=86=85=E5=AE=B9=E6=88=96=E5=85=B6=E9=99=
=84=E4=BB=B6=E3=80=82=E5=A6=82=E6=82=A8=E8=AF=AF=E6=94=B6=E6=9C=AC=E9=82=AE=
=E4=BB=B6=EF=BC=8C=E8=AF=B7=E5=8D=B3=E4=BB=A5=E5=9B=9E=E5=A4=8D=E6=88=96=E7=
=94=B5=E8=AF=9D=E6=96=B9=E5=BC=8F=E9=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=
=BA=EF=BC=8C=E5=B9=B6=E5=B0=86=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6=E3=80=81=
=E9=99=84=E4=BB=B6=E5=8F=8A=E5=85=B6=E6=89=80=E6=9C=89=E5=A4=8D=E6=9C=AC=E5=
=88=A0=E9=99=A4=E3=80=82=E8=B0=A2=E8=B0=A2=E3=80=82
The contents of this message and any attachments may contain confidential a=
nd/or privileged information and are intended exclusively for the addressee=
(s). If you are not the intended recipient of this message or their agent, =
please note that any use, dissemination, copying, or storage of this messag=
e or its attachments is not allowed. If you receive this message in error, =
please notify the sender by reply the message or phone and delete this mess=
age, any attachments and any copies immediately.
Thank you
