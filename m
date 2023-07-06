Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAD3749E7C
	for <lists+io-uring@lfdr.de>; Thu,  6 Jul 2023 16:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjGFOEL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Jul 2023 10:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjGFOEK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Jul 2023 10:04:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605851FEF
        for <io-uring@vger.kernel.org>; Thu,  6 Jul 2023 07:03:55 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-676cc97ca74so150177b3a.1
        for <io-uring@vger.kernel.org>; Thu, 06 Jul 2023 07:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688652235; x=1691244235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WhSDI9mp0MYKeqY0tJX7SergTVTmGv0F/ckbyNmGNLQ=;
        b=FMqh2CmzOm6XDjJjezWBlN875lQ5T+a7DnklQNymtU9D+p4Vamdg/lVJcXx5LK9wQB
         KMF3m7xyChwczs3gSrW0hfYLg6AHUOPg2tw1QHIcglCDiKzSYTOIQrtnMYep6XtsjIep
         DxJJ6tEz23KWKTCsBzXv4e2DMZK0tudoGmt64Vn23mE4w14gdIX8FajdCS/c+EBdj4BM
         OLhNcMy3ZYtdTw3gnyRZjxn7tMXpguxXzPohD9RzlAV02/2dZlziCIX9IP1zVTQgKS/1
         HI6e6TX7bpBdHRlpwO53EfTwR3UPufykmkpeAJRybBh5mzEiKnBBl2q/GqPD8Ytlw/Gs
         lsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688652235; x=1691244235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WhSDI9mp0MYKeqY0tJX7SergTVTmGv0F/ckbyNmGNLQ=;
        b=lllMTn+kXnr25Bw+0f0P7ZqzOH+UC2ngduGjlsynce6UMRSkJsfZH9Sxzn7iMCbwYX
         fSk1AEch4dK0wNOzkT6R00tRc7f+TSg7PX5bhLT04g67YtHQ2mMVyqyVte3h8qddYQbq
         IutbnpHvzkiZrWLQ14iRhTCyOxr2XwyldC4SLFH24nJN4AUX8B1Xlejh4XLEYYyCuxRy
         eVGqm5bUWC/xiC7oiFIq+vVryhUPQG/kjFj2vWYXkUGdKcCTNtbV4xf1OPz/FaT5/q6c
         Nc4BZipT/DYLoeAtzzr0xpjZ4n3mZswmmhOpe/RKSiC693z1BgCq6cDqqOn9DrZDCCkN
         r7nQ==
X-Gm-Message-State: ABy/qLYeY89GPllY9iMhCOoXcrt2qRfo7d2gt2TtIev3MjuzqqbCwKBF
        DsNFwQMBD6L5YbUVhb83YiYriQ==
X-Google-Smtp-Source: APBJJlHWx70FxXddJLp/svv44qJ/lHFgMni3NpkbFoqzcjvrqGi64yR8YRM3ydyDuI4xKaOrlEAb7Q==
X-Received: by 2002:a05:6a20:7495:b0:12d:2abe:549a with SMTP id p21-20020a056a20749500b0012d2abe549amr2182854pzd.6.1688652234613;
        Thu, 06 Jul 2023 07:03:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z21-20020aa791d5000000b0063b898b3502sm1322987pfa.153.2023.07.06.07.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jul 2023 07:03:53 -0700 (PDT)
Message-ID: <ec9b55b5-c64c-3ea4-9f39-128cd2e0a8ac@kernel.dk>
Date:   Thu, 6 Jul 2023 08:03:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] Fix max/min warnings in virtio_net, amd/display, and
 io_uring
Content-Language: en-US
To:     Alex Deucher <alexdeucher@gmail.com>, Yang Rong <yangrong@vivo.com>
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
References: <20230706021102.2066-1-yangrong@vivo.com>
 <CADnq5_MSkJf=-QMPYNQp03=6mbb+OEHnPFW0=WKiS0VMc6ricQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADnq5_MSkJf=-QMPYNQp03=6mbb+OEHnPFW0=WKiS0VMc6ricQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/23 7:58?AM, Alex Deucher wrote:
> On Thu, Jul 6, 2023 at 3:37?AM Yang Rong <yangrong@vivo.com> wrote:
>>
>> The files drivers/net/virtio_net.c, drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c, and io_uring/io_uring.c were modified to fix warnings.
>> Specifically, the opportunities for max() and min() were utilized to address the warnings.
> 
> Please split this into 3 patches, one for each component.

Don't bother with the io_uring one, code is far more readable as-is.

-- 
Jens Axboe

