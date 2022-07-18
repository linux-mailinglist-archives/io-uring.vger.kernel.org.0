Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2C5783EE
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiGRNlP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 09:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiGRNlO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 09:41:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394761BE9C
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:41:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so12628173pjl.4
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fvz38PmjhHC1WI5IUI2ZwHUKtL8FMZ2SmfONlHtzHCw=;
        b=q05wScDmU17P25suYMiA7lScN9AnTHlNoeDYB0GQraMGC2Tf9wNwaFBeP3akdaDTM0
         bKSw+c3FAzsGaNugj4LVbs/XM8RVIqdAJmtBhndhiZND+neNctUnuJHx2DSHDkfu4ksO
         XA/slwjF2uV892HYOKszi5RiWN9ql/fx4ce+CcFmIlaRBOL57IFE4kq8kR+Mih1BP1lJ
         PP/CjQT7HjfcQHr1EP/Yw6RSNIMrmpfCABYtCGvUuOPXhngxrBzqYW957FxtCeiEsi4z
         vEQsYsp7hd96LZCKJ7f36m7ZqZOQNYG0Z6PhoOwgyOHdeU6FmW3kjiF8KSQ8Ty5wQucM
         N70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fvz38PmjhHC1WI5IUI2ZwHUKtL8FMZ2SmfONlHtzHCw=;
        b=OkNpy9lZAsGKzdhvn7haaRMNFfAQoergw1FamOziaAWvoii9xysfH1hi0XiKkrEBbj
         HzHczBDTBH4rh2UzfTs4gABXKmBwW89qfzR3SzVZUTBYREw2JzqN6o8T2X2Gx0GC10Fd
         X/8hYwEPZCmjIlwN9PKgNQN4KgLHd5jiacgMkrNGsilggMFqBp0bjTitZW9h9T/AJY3k
         tFBeA2MWzkjI2u7KYVcEapUUr5E3uLQac1jg8e3MZCD2Hh1bylcjKBQMu0/KDAyU4Czk
         5lCmJXHUCcdMPTCA7UBffKkETmHGOE6dcQkD574axfprH9NnKc6EXjsdH36u6mWVFz5r
         Jiug==
X-Gm-Message-State: AJIora8IByIlVMT+3DGkq8B/jRx5S/QN1XIBGzwUPX6gmLd7fiFqbaJE
        eC8tShhAt4PqAiSXs+LjR5696g==
X-Google-Smtp-Source: AGRyM1uqCBq1Q4pVLVlQR50443SXYf3zzsB79PUwCU+1MXMX2dTuH4hrGS+50NvjaOtTCmfcGxupbA==
X-Received: by 2002:a17:902:778a:b0:16c:a1c9:7b14 with SMTP id o10-20020a170902778a00b0016ca1c97b14mr24845430pll.116.1658151672568;
        Mon, 18 Jul 2022 06:41:12 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903244d00b0016bfa1a5170sm7773112pls.285.2022.07.18.06.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 06:41:12 -0700 (PDT)
Message-ID: <bcca1dd5-4379-72bb-de69-8d229f191b4b@kernel.dk>
Date:   Mon, 18 Jul 2022 07:41:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing] fix io_uring_recvmsg_cmsg_nexthdr logic
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Kernel-team@fb.com
References: <20220718133429.726628-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220718133429.726628-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/22 7:34 AM, Dylan Yudaken wrote:
> io_uring_recvmsg_cmsg_nexthdr was using the payload to delineate the end
> of the cmsg list, but really it needs to use whatever was returned by the
> kernel.

Thanks, this works for me. I'll add it with a tested-by as well.

-- 
Jens Axboe

