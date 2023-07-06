Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A9C749E74
	for <lists+io-uring@lfdr.de>; Thu,  6 Jul 2023 16:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjGFODM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Jul 2023 10:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjGFODL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Jul 2023 10:03:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4511BD9
        for <io-uring@vger.kernel.org>; Thu,  6 Jul 2023 07:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688652144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0GE7k8I9982HVE9TTWbDiwrZOKfvdOMPK3S9DyegjXE=;
        b=cbxyYykZzhc3Q3Il8Z5x2aNt/bgOIqcWWKFZFguc1L7aDjTfgT+oXs9aDJdgzGXckGnQZp
        WW6oYUYxftDEXGE334E9fISscDyjX1epE8MeJ287EisttCFJXgYGQd5VQULZhHV2jREJjf
        jZqPuix2CddrEqT0aXFhLc7k8ZAcXDE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-zWK4KsFyPdOdNgLtvJKYFA-1; Thu, 06 Jul 2023 10:02:22 -0400
X-MC-Unique: zWK4KsFyPdOdNgLtvJKYFA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-314394a798dso423161f8f.0
        for <io-uring@vger.kernel.org>; Thu, 06 Jul 2023 07:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688652140; x=1691244140;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0GE7k8I9982HVE9TTWbDiwrZOKfvdOMPK3S9DyegjXE=;
        b=j2Z7o/7jJ7ysOwxr8TCeA1CCIIWxoFbvn+2gxdwjuVpSo+WRfZfRc+nY6TavYq9YGI
         Cg6HAk/J1Q1+F0DM/AtXXpEndHi7NNWA7CKC3vTFENMuU8xC4OB3wII4Wh9m8XC2aWYb
         rPKqn3pMWKcM4D/9S38I1Q8O8OalIbw6nc5ma5LCpKFbS9Dz1TzKv9Ysn+/rjVDNsQp6
         ujxkB9nt8MUHbkyi5OMajjKV7D8y261Cc6c4UQ8jXQhtzBsDIdPfpmMJY7bWmmbnut5F
         dbSHrj3yWOK1Qa7SZTz1LsmzNjhewJWIMvFJpLRtfybqFcQD1tl4VZIYxcr9MuS1PSLn
         CaiQ==
X-Gm-Message-State: ABy/qLZ9heWul4Y3udYC/+96+Qgacz6BBTGjSrMxQeP4SXdMAuFGT6qf
        TBpq/tFjxSxvMtBAaDUv2gK5XXeCFd8Lksx+6Zjgy2OW598OU48ad4zQTf+vOumLvuKjBqbYDqV
        I4QxR0xgEblUnhR16qbg=
X-Received: by 2002:a5d:4e12:0:b0:313:e2c8:bed1 with SMTP id p18-20020a5d4e12000000b00313e2c8bed1mr2235677wrt.34.1688652140612;
        Thu, 06 Jul 2023 07:02:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHcrZAK048UNMfdOsb+IYlPvPsKZoDto6N+0HK8CkttE8tg+x61xjZ/Drujf9ZKOumGT2ngEg==
X-Received: by 2002:a5d:4e12:0:b0:313:e2c8:bed1 with SMTP id p18-20020a5d4e12000000b00313e2c8bed1mr2235624wrt.34.1688652140228;
        Thu, 06 Jul 2023 07:02:20 -0700 (PDT)
Received: from redhat.com ([2.52.13.33])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d4742000000b0031434936f0dsm1960350wrs.68.2023.07.06.07.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 07:02:19 -0700 (PDT)
Date:   Thu, 6 Jul 2023 10:02:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yang Rong <yangrong@vivo.com>
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
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
        "open list:AMD DISPLAY CORE" <amd-gfx@lists.freedesktop.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        opensource.kernel@vivo.com, luhongfei@vivo.com
Subject: Re: [PATCH] Fix max/min warnings in virtio_net, amd/display, and
 io_uring
Message-ID: <20230706100133-mutt-send-email-mst@kernel.org>
References: <20230706021102.2066-1-yangrong@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230706021102.2066-1-yangrong@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 06, 2023 at 10:06:16AM +0800, Yang Rong wrote:
> The files drivers/net/virtio_net.c, drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c, and io_uring/io_uring.c were modified to fix warnings.

what warnings? the point of the warning is to analyze it not "fix" it
blindly.

> Specifically, the opportunities for max() and min() were utilized to address the warnings.
> 
> Signed-off-by: Yang Rong <yangrong@vivo.com>
> ---
>  drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 6 +++---
>  drivers/net/virtio_net.c                     | 3 ++-
>  io_uring/io_uring.c                          | 3 ++-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
> index c753c6f30dd7..df79aea49a3c 100644
> --- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
> +++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
> @@ -22,7 +22,7 @@
>   * Authors: AMD
>   *
>   */
> -
> +#include <linux/minmax.h>
>  #include "dc.h"
>  #include "dc_dmub_srv.h"
>  #include "../dmub/dmub_srv.h"
> @@ -481,7 +481,7 @@ static void populate_subvp_cmd_drr_info(struct dc *dc,
>         max_drr_vblank_us = div64_u64((subvp_active_us - prefetch_us -
>                         dc->caps.subvp_fw_processing_delay_us - drr_active_us), 2) + drr_active_us;
>         max_drr_mallregion_us = subvp_active_us - prefetch_us - mall_region_us - dc->caps.subvp_fw_processing_delay_us;
> -       max_drr_supported_us = max_drr_vblank_us > max_drr_mallregion_us ? max_drr_vblank_us : max_drr_mallregion_us;
> +       max_drr_supported_us = max(max_drr_vblank_us, max_drr_mallregion_us);
>         max_vtotal_supported = div64_u64(((uint64_t)drr_timing->pix_clk_100hz * 100 * max_drr_supported_us),
>                         (((uint64_t)drr_timing->h_total * 1000000)));
> 
> @@ -771,7 +771,7 @@ void dc_dmub_setup_subvp_dmub_command(struct dc *dc,
>                 wm_val_refclk = context->bw_ctx.bw.dcn.watermarks.a.cstate_pstate.pstate_change_ns *
>                                 (dc->res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000) / 1000;
> 
> -               cmd.fw_assisted_mclk_switch_v2.config_data.watermark_a_cache = wm_val_refclk < 0xFFFF ? wm_val_refclk : 0xFFFF;
> +               cmd.fw_assisted_mclk_switch_v2.config_data.watermark_a_cache = min(wm_val_refclk, 0xFFFF);
>         }
> 
>         dm_execute_dmub_cmd(dc->ctx, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9b3721424e71..5bb7da885f00 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -22,6 +22,7 @@
>  #include <net/route.h>
>  #include <net/xdp.h>
>  #include <net/net_failover.h>
> +#include <linux/minmax.h>
> 
>  static int napi_weight = NAPI_POLL_WEIGHT;
>  module_param(napi_weight, int, 0444);
> @@ -1291,7 +1292,7 @@ static struct sk_buff *build_skb_from_xdp_buff(struct net_device *dev,
>         __skb_put(skb, data_len);
> 
>         metasize = xdp->data - xdp->data_meta;
> -       metasize = metasize > 0 ? metasize : 0;
> +       metasize = max(metasize, 0);
>         if (metasize)
>                 skb_metadata_set(skb, metasize);
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e8096d502a7c..875ca657227d 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -47,6 +47,7 @@
>  #include <linux/refcount.h>
>  #include <linux/uio.h>
>  #include <linux/bits.h>
> +#include <linux/minmax.h>
> 
>  #include <linux/sched/signal.h>
>  #include <linux/fs.h>
> @@ -2660,7 +2661,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>                                         page_array);
>         if (ret != nr_pages) {
>  err:
> -               io_pages_free(&page_array, ret > 0 ? ret : 0);
> +               io_pages_free(&page_array, max(ret, 0));
>                 return ret < 0 ? ERR_PTR(ret) : ERR_PTR(-EFAULT);
>         }
>         /*
> --
> 2.35.3
> 
> 
> ________________________________
> 本邮件及其附件内容可能含有机密和/或隐私信息，仅供指定个人或机构使用。若您非发件人指定收件人或其代理人，请勿使用、传播、复制或存储此邮件之任何内容或其附件。如您误收本邮件，请即以回复或电话方式通知发件人，并将原始邮件、附件及其所有复本删除。谢谢。
> The contents of this message and any attachments may contain confidential and/or privileged information and are intended exclusively for the addressee(s). If you are not the intended recipient of this message or their agent, please note that any use, dissemination, copying, or storage of this message or its attachments is not allowed. If you receive this message in error, please notify the sender by reply the message or phone and delete this message, any attachments and any copies immediately.
> Thank you

