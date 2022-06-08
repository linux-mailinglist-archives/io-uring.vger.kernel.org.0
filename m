Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C10542F42
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 13:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbiFHLd4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 07:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiFHLdi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 07:33:38 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4631C7924;
        Wed,  8 Jun 2022 04:33:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a10so8203582wmj.5;
        Wed, 08 Jun 2022 04:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IIkBujwmb5Lrg4qmd10yFjvv9HiV93pnXku/QgZ4V9Q=;
        b=k7tkpgZNBRFh0LjrETUNaPCCn4yfM7te7o+ST6rpQAfE/qxKzGLMT/x3JwMTAXfoyS
         248gjr6yD6JHOe3U1vcWQRxUC6/khb2XRumjw45rSJ5r8Qq8xF2jplhHPwDyM9cSfJQf
         7MnZ3c+6H4tyXGGRSfPUEUEaf8oT4S5cu9F7Ri120cAVNGF0BxXOz1p5hTgo91XyPMi/
         yh8gwB+mh0SUSBCfHAY5BRf2/HO0dJrSX5laes3nwZyM0XHMPTg4UWNUrbjQn2yGiCPt
         rZEi3NT7Sikt2DhUUBWY0BYiOlfmphB7shrGS4m5FteyxMwvSMoHp/H9vnShtRF9YVaE
         4CDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IIkBujwmb5Lrg4qmd10yFjvv9HiV93pnXku/QgZ4V9Q=;
        b=N6i14ekAigshw9TFqf9KbXCdD9+3pFUgUJbtkRwJ/LrGCHdNopvCvKT0xoQALw2oQU
         8zjk9O/Xg+j6Iv/TGpph6rQT0ujc27LCWcBjQTI+WqFcT8aBB7vLJ4qxn2I7+kU31fw1
         3GWfo+O8u9nKHL4gGdc7eEEXDRwEY/EXDclDdOa87AyUD7Ne2dpQ3dboxufJlGRvDYYF
         KZD0IXHcooQ7iXZ8p5slCr7DJr3sNBUYtiw5E85ga/FkIQ0BzFnKBI7yOKQ6/Ym6v4+y
         +5zQNo+ho8+vRPuJQ9HVnVbJ0HwY0avjRaU/lklbOGaw/6Bz6rvS1K5RescGWEL1R5Wx
         mivA==
X-Gm-Message-State: AOAM5305by+PNfzyBnv8AHnSoxGG+7SkyKCovHAsTeihgONblrsXmjkR
        0seclJihN3+Oi6YksviTpB4=
X-Google-Smtp-Source: ABdhPJwjqiFxKLygxZXvw5czUgJQVHljIuIZQWxATVeZ6iv5YixKTMaUUD5fr+RmoKeTTdI4UXoq1g==
X-Received: by 2002:a7b:c5cb:0:b0:397:47ae:188f with SMTP id n11-20020a7bc5cb000000b0039747ae188fmr63350107wmk.137.1654688005318;
        Wed, 08 Jun 2022 04:33:25 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id d14-20020a5d6dce000000b0020c5253d927sm21196014wrz.115.2022.06.08.04.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jun 2022 04:33:24 -0700 (PDT)
Message-ID: <e309bd03-a3da-096b-9abe-9308084e4107@gmail.com>
Date:   Wed, 8 Jun 2022 12:33:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC 0/5] support nonblock submission for splice pipe to pipe
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
References: <20220607080619.513187-1-hao.xu@linux.dev>
 <d350c35e-1d73-b2c8-5ae4-e6ead92aebba@gmail.com>
 <68b1a721-217a-f52b-ae41-0faec77edf3f@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <68b1a721-217a-f52b-ae41-0faec77edf3f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/22 05:19, Hao Xu wrote:
> On 6/7/22 17:27, Pavel Begunkov wrote:
>> On 6/7/22 09:06, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> splice from pipe to pipe is a trivial case, and we can support nonblock
>>> try for it easily. splice depends on iowq at all which is slow. Let's
>>> build a fast submission path for it by supporting nonblock.
>>
>> fwiw,
>>
>> https://www.spinics.net/lists/kernel/msg3652757.html
>>
> 
> Thanks, Pavel. Seems it has been discussed for a long time but the
> result remains unclear...For me, I think this patch is necessary for getting a good SPLICE_F_NONBLOCK user experience.

I quite agree here, something like this is much needed.
The performance of io_uring pipe I/O is miserably slow

-- 
Pavel Begunkov
