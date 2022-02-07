Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E014AC440
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 16:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiBGPq5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 10:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345487AbiBGPhz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 10:37:55 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747CC0401CF
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 07:37:54 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id s18so17187500ioa.12
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 07:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OVQkazA38Xs9TAErBTjWdO6iUtOuwl/winaYJ9o81FU=;
        b=48XlmHJS3i0F3tDt8IW0RPM3YClhDQwRwMrwLBb2zN9KGmi6BULuL/eoN60AZtMDTp
         dI9oc4EWlTAyVpe9OK+NVU2RFXFVZ+n70oJwyW+EW1xkrBX/+ZJ/ibA/qOCBcMpE+WqK
         etwyeVa2uJjc26Wckq74cCNHsYm5qebX8cDv3FiJLbqNnKUleCh5i92zCtCdzh/NYocQ
         nmyCcJ2iGPu/K+wD/njpw0wjqBKzP6J9AwMqZ72ptG6zZSAeXNzg+SzEuTnvogeWGAQi
         kKlCsRrcdujp4G/usKOvDv3eCoaouB7/HjNgymyeIt21prhZflRIDdRjMmj2bxQiB3+E
         tH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OVQkazA38Xs9TAErBTjWdO6iUtOuwl/winaYJ9o81FU=;
        b=QXLN4VmW8cGOejaoLyJhxlVUKxK/y3jqRzdbT9BHgzt/ruTVL3YbEi3LI8MqhOFA9R
         M91MDm7lCrvKQqueRJxi0HUzScoLQLZ5Iz1KKN1h1dXPXNBp0MLlfusNpMxiTBNuKO37
         FgabJQ2uIy06V/gy0aeWasWf2YegQ089loluVbMNscLGMyRm6ZQlIhLEX6BfsUwm/RBC
         dKrxagh2k1kcw2r6CeFw+njj1M7DtcL6KCGPZB0homXOSEwDXOkb9wXiNQsCC8+tVr4L
         zBjTK43a0ZNwEsdJaqdKhuqkFU8OyGNCY7aYhDSXzrlie9nrUahxD2bcZVN3xTYnPfYJ
         8bPg==
X-Gm-Message-State: AOAM530b0BeCoa9V7G9AdCxzMtkiYZmEMDpOjXRHC7v/KgfxO7dfOYW/
        VdIepN0BdgxhS2yyk5hmyTD/2Q==
X-Google-Smtp-Source: ABdhPJwEVJPTtO4O5g1aR8TU5u2jGY2/Fd+8lMSh+MkotBvUoDaXZ/ULqHa0zOSCIghSgzPfUnSPKA==
X-Received: by 2002:a05:6638:1305:: with SMTP id r5mr112912jad.154.1644248273876;
        Mon, 07 Feb 2022 07:37:53 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p11sm6431831iov.38.2022.02.07.07.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 07:37:53 -0800 (PST)
Subject: Re: [PATCH io_uring-5.17] io_uring: Fix build error potential reading
 uninitialized value
To:     Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com>
 <20220207114315.555413-1-ammarfaizi2@gnuweeb.org>
 <91e8ca64-0670-d998-73d8-f75ec5264cb0@kernel.dk>
 <20220207142046.GP1978@kadam>
 <CAOG64qN1fQ_surhMJSuygyf_emSvFm3HKRgj_JAZteFVjaP3+A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3373f74-d7a5-6279-0440-2342092eef90@kernel.dk>
Date:   Mon, 7 Feb 2022 08:37:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOG64qN1fQ_surhMJSuygyf_emSvFm3HKRgj_JAZteFVjaP3+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/22 7:33 AM, Alviro Iskandar Setiawan wrote:
> On Mon, Feb 7, 2022 at 9:21 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> On Mon, Feb 07, 2022 at 06:45:57AM -0700, Jens Axboe wrote:
>>> On 2/7/22 4:43 AM, Ammar Faizi wrote:
>>>> From: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
>>>>
>>>> In io_recv() if import_single_range() fails, the @flags variable is
>>>> uninitialized, then it will goto out_free.
>>>>
>>>> After the goto, the compiler doesn't know that (ret < min_ret) is
>>>> always true, so it thinks the "if ((flags & MSG_WAITALL) ..."  path
>>>> could be taken.
>>>>
>>>> The complaint comes from gcc-9 (Debian 9.3.0-22) 9.3.0:
>>>> ```
>>>>   fs/io_uring.c:5238 io_recvfrom() error: uninitialized symbol 'flags'
>>>> ```
>>>> Fix this by bypassing the @ret and @flags check when
>>>> import_single_range() fails.
>>>
>>> The compiler should be able to deduce this, and I guess newer compilers
>>> do which is why we haven't seen this warning before.
> 
> The compiler can't deduce this because the import_single_range() is
> located in a different translation unit (different C file), so it
> can't prove that (ret < min_ret) is always true as it can't see the
> function definition (in reality, it is always true because it only
> returns either 0 or -EFAULT).

Yes you are right, I forgot this is the generic helper, and not our
internal one.

>> No, we disabled GCC's uninitialized variable checking a couple years
>> back.  Linus got sick of the false positives.  You can still see it if
>> you enable W=2
>>
>> fs/io_uring.c: In function ‘io_recv’:
>> fs/io_uring.c:5252:20: warning: ‘flags’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>   } else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
>>              ~~~~~~~^~~~~~~~~~~~~~
>>
>> If you introduce an uninitialized variable bug then likelyhood is the
>> kbuild-bot will send you a Clang warning or a Smatch warning or both.
>> I don't think anyone looks at GCC W=2 warnings.
>>
> 
> This warning is valid, and the compiler should really warn that. But
> again, in reality, this is still a false-positive warning, because
> that "else if" will never be taken from the "goto out_free" path.

Right, as mentioned in my email, there is no bug there. But I do like
the patch as it cleans it up too, the error-out path should not include
non-cleanup items.

-- 
Jens Axboe

