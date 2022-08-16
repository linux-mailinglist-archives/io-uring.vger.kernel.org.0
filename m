Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78E5960AF
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiHPQ5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 12:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiHPQ5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 12:57:43 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F5E80B5B
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 09:57:41 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p184so5325593iod.6
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 09:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=P7J3DKwpdJQSLzw9TsqI+Lj/vSSoU3YjZYr+/erVr98=;
        b=H1yQv/LVjOxKe3NI51kX91Krb9mhxyyXprm9qj+Aj0yDTp0jTFIjJrx2vcdT6Necx5
         GmIy25qW/vZvoDQ4WVA+IT09gEYPPbgRE3aIaqUZXX6LKnScgOQmKXKSZ1putqjOaoYO
         rSVB8y/5QrJXNJd1uR8w9GdAUH8zW5MDvkrG9k6xVwFTy2lgTVQxjcIki6l6ilAyrD4r
         NZh2aee2THaR6oImlOFbtAjgSzBEbCrFrSyXT40QWWeaQ0ECr3LxZ3oYGchKNRZ8QCQJ
         xZsqtsXsuo4AfKfE9raGe2vR0RSXMX4fPEhfKocrNKRY7zu3clpX+F0FmKHDDQaJw+1A
         h10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=P7J3DKwpdJQSLzw9TsqI+Lj/vSSoU3YjZYr+/erVr98=;
        b=pmLv9YCdLRdZ3Z5txFFij4/FFv/gehvGnsh7GanvKZyikzHhlN+KTQthgeNVgXjEL+
         HzTIPgqyojjfuBhfmGgks/7fePQZpaZI9SwclGn/wWQ4+a+1hFF0HIET15kyA+2pVElO
         9y+IHjdaEC18fSbC+iC3P6W42hSzJDPCSFajsacAqZ3rSdcDNbhtNX1iSoLEc11mFoHG
         I55oZn+K0ujEXMT+CbaAUSMsvzxkGpNFtJbxNyuiz+w2zuSGWyUsPjtiDpJJPUw4Ltbh
         Ldhp/eMg0Yl2boS6WkqhpUZPE20o9NXkH/luQaAjK7MTDEziGP5al5qibT+Ml7AF99MN
         3jpw==
X-Gm-Message-State: ACgBeo2DTna0nXcih/WmYtXWtva8ESe5eXIkSKKRRrHoe7xxi7paVCDE
        L8zbgL7P9/Hq0Ab4hmoBfYTU1g==
X-Google-Smtp-Source: AA6agR6uCjKt17c2fhPSjQg6NHiFFMA6kakU/SEBd+msRzj+eLPE+hbwwRRrCXyILrOCHDQww+Dr8w==
X-Received: by 2002:a02:9714:0:b0:343:5c61:8409 with SMTP id x20-20020a029714000000b003435c618409mr9948266jai.277.1660669060767;
        Tue, 16 Aug 2022 09:57:40 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g10-20020a056602072a00b0068844be44d7sm3277830iox.6.2022.08.16.09.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 09:57:40 -0700 (PDT)
Message-ID: <5bf54200-5b12-33b0-8bf3-0d1c6718cfba@kernel.dk>
Date:   Tue, 16 Aug 2022 10:57:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.1
Subject: Re: KASAN: null-ptr-deref Write in io_file_get_normal
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiacheng Xu <578001344xu@gmail.com>
Cc:     linux-kernel@vger.kernel.org, asml.silence@gmail.co,
        io-uring@vger.kernel.org, security@kernel.org
References: <CAO4S-mdVW5GkODk0+vbQexNAAJZopwzFJ9ACvRCJ989fQ4A6Ow@mail.gmail.com>
 <YvvD+wB64nBSpM3M@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YvvD+wB64nBSpM3M@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/22 10:21 AM, Greg KH wrote:
> On Wed, Aug 17, 2022 at 12:10:09AM +0800, Jiacheng Xu wrote:
>> Hello,
>>
>> When using modified Syzkaller to fuzz the Linux kernel-5.15.58, the
>> following crash was triggered.
> 
> As you sent this to public lists, there's no need to also cc:
> security@k.o as there's nothing we can do about this.

Indeed...

> Also, random syzbot submissions are best sent with a fix for them,
> otherwise it might be a while before they will be looked at.

Greg, can you cherrypick:

commit 386e4fb6962b9f248a80f8870aea0870ca603e89
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Jun 23 11:06:43 2022 -0600

    io_uring: use original request task for inflight tracking

into 5.15-stable? It should pick cleanly and also fix this issue.

-- 
Jens Axboe


