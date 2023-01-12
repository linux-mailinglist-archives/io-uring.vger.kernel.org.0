Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8472667DD7
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbjALSUd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 13:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240571AbjALSST (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:18:19 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0778AD93
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:49:41 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id i17so4871388ila.9
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5GFvqx4FzbWQGbBOREW005WmRRHc7diKsmagdyp2KsU=;
        b=qdfxnHI3Gx6paqlLM60TGzt7aWbZ+OmuGJyGGHlA7dmBwgt7VgdD8T09MfAficr8k9
         jGmX8zdCyAn6/zVv/zwJG5jYGIEeuKbfbPY4v6cI6K5D6/Dc+Mm4Z4m442i4/lnAfwao
         4F/rB22tbAFnbWt6yC6PAu80PVKXLDZdOdsS2xq0pJS8AWfsZ3n0qilwPqwfea78R8oa
         OqtB98qqiUWZEZnqK/sD5GHInpDe8krKzu4Nju/3K2nKRX+cDFJ2Gs/ZTRTshff4hRVK
         EptFAYltRsr8HFltfJLa7jeJSx/KjEtkM9m5mDSzzeEIXQPFgPPWjMLEVgKmVo+b4A81
         vIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5GFvqx4FzbWQGbBOREW005WmRRHc7diKsmagdyp2KsU=;
        b=hnWTZ3xRQR9AaWNATVFgm7F+nCch9+lGQB8nHQLoFqZSmDU/x9zR16SZ0LeHfn3Gqt
         /XOBTYYBfCOZnhETqcS9JavAEwmJ738165y+FFkTi1UOn2ZkqWwPZt0xPKNz5RRebB8+
         JhoSEq0qWJRFwx9Yp+gHeWBb6W7rg5dSwvPvC+71FMGQyg+9mHGWz+QPT/yWLiXN6TbD
         c/MAF8ahbCgsHjrcYlsZP1vmsiekEvdq+rz554zf/sUIKLQVuL/gtthFbuOloiaEyhOl
         t9kpQ+Fh2aO1meRRRT/5V+LwPmZJ9fm2UrzdzCHpabK88oNg2CGdCd4muzFB56mAgEW2
         zPHQ==
X-Gm-Message-State: AFqh2kp6eLGhMqaY6uFAqUB6E6nW9lADTBduWE4eEYiN/2t78Hl4ZKzG
        74jXXu6rXfOK0wgxNxtBT6XFpA==
X-Google-Smtp-Source: AMrXdXsU2SdqbLtzlRfgTdwYRCGp8ssnB1/ewp5tlLKSJ4HjfVWFZHDIZfR/z2cp6TokqRte7RjztA==
X-Received: by 2002:a92:c9cb:0:b0:304:c683:3c8a with SMTP id k11-20020a92c9cb000000b00304c6833c8amr10786050ilq.3.1673545780258;
        Thu, 12 Jan 2023 09:49:40 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r6-20020a924406000000b0030d86710f31sm5353398ila.1.2023.01.12.09.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 09:49:39 -0800 (PST)
Message-ID: <cb37f2f8-fb29-c583-6a12-57df2fadf811@kernel.dk>
Date:   Thu, 12 Jan 2023 10:49:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH liburing v1 4/4] man/io_uring_prep_splice.3: Explain more
 about io_uring_prep_splice()
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20230112155709.303615-1-ammar.faizi@intel.com>
 <20230112155709.303615-5-ammar.faizi@intel.com> <87bkn3ekbb.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87bkn3ekbb.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 10:26 AM, Gabriel Krisman Bertazi wrote:
> Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:
> 
>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>
>> I have found two people confused about the io_uring_prep_splice()
>> function, especially on the offset part. The current manpage for
>> io_uring_prep_splice() doesn't tell about the rules of the offset
>> arguments.
>>
>> Despite these rules are already noted in "man 2 io_uring_enter",
>> people who want to know about this prep function will prefer to read
>> "man 3 io_uring_prep_splice".
>>
>> Let's explain it there!
> 
> Hi Ammar,
> 
> A few suggestions below:

[snip]

Shoot, missed this. Ammar, can you send a fixup patch with the below
suggestions?

-- 
Jens Axboe


