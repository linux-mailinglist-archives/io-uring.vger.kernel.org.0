Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1152535822
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 05:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiE0Dwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 23:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiE0Dwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 23:52:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673A15D185
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 20:52:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nn3-20020a17090b38c300b001e0e091cf03so2118986pjb.1
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 20:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PUU6jV/okvcaLNUuSIYq9Cg4B6dwyB1VCgeJBcCaDFs=;
        b=TMyiWKo5Wap62zAC7Ozrb43bg1885/hudiV/DvE72Ephv6h8AOhgCFTb8+hzkJZPt9
         I85+MWY1WI5vYVfeFSwQePBmLOFXKwiyERt2j/UL8P7PvuchgMWvDCVtkYueJFXub0dt
         hDqFppylw+KRWp+yOYv4K7DPAbVczBhef3mtN0si4MBcEH6D8v5wPZDoWp+fEQqTkzKV
         iOMi0PI/zs+3SS2vprZMHjDnVYUz+yGAQv0gWjL2MVpRlSXtwhAW72V//zVRy58QsPG7
         Pv/yAzPkgg/rntc0oKzFRAuyoyxbeImPVpEnlt0ubmRf3wIs+Nh9GEeaFB+lOzHmtfaz
         htfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PUU6jV/okvcaLNUuSIYq9Cg4B6dwyB1VCgeJBcCaDFs=;
        b=IisnU/7qRXICDbebJUgFerbGSYOokOdftEi//MoVK/SICa4ZPOJTY5zSKNhVRPS+Mr
         HeyOoEv5kjQGMzCM8PZrwsIiXtqx2pUrWKwMZwD9KZ/k1nTZqVMsFhoE6uVxMPZPCRhe
         y4s22/yTZojZSvjJCEKqzmGNsT95SZTTfBHjF/O7feygYb2e5x/vXQszafq00qdjht/K
         cp7ycNRUpGfv5iwyi4a3S1Th73QssOHoVVUkI9s8MotH7NS2r0Swe9WsjUhDPBRI8bHc
         RWn17KtqKOiny71aBjawVjtvc2DvZCf/ynaFsUK5UQ0tzhIq5H0ay5wnRPxof9EWbMn+
         37mg==
X-Gm-Message-State: AOAM531VDmMt5rPM3D8KYNa2cXMTnD2I0SwsThjl6IKLlFLUjPZ5rcg0
        6JqDXzsmr+kaUmHxBknxsRSa3Q==
X-Google-Smtp-Source: ABdhPJw3XFRbbQ6j6O7nVKP272Yx3AlvaWzl8KMIY7Pxer8jrHr/pVs65wMuj6MoXRGIpjbhcI//2A==
X-Received: by 2002:a17:90a:eac5:b0:1e2:7aa9:2d8a with SMTP id ev5-20020a17090aeac500b001e27aa92d8amr1070517pjb.87.1653623557716;
        Thu, 26 May 2022 20:52:37 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w6-20020a626206000000b0050dc762819bsm2278088pfb.117.2022.05.26.20.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 20:52:36 -0700 (PDT)
Message-ID: <b64a8869-b1f3-f1f7-bc04-64e3be626cd2@kernel.dk>
Date:   Thu, 26 May 2022 21:52:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] io_uring: ensure fput() called correspondingly when
 direct install fails
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220527025400.51048-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527025400.51048-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/22 8:54 PM, Xiaoguang Wang wrote:
> io_fixed_fd_install() may fail for short of free fixed file bitmap,
> in this case, need to call fput() correspondingly.

Good catch - but it's a bit confusing how we handle this case
internally, and the other error case relies on that function doing the
fput (which it does).

Any chance we can get that cleaned up at the same time? Would make
errors in this error less likely in the future.

-- 
Jens Axboe

