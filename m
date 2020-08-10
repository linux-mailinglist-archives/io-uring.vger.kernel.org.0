Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4687C240CBD
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgHJSLm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 14:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728116AbgHJSLl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 14:11:41 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E3EC061788
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 11:11:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o1so5442328plk.1
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 11:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S0kQGL1Z8bJks/onFWo7b2UmOXKnEogpEFfQxSaoZZQ=;
        b=BsvJhtuEB8EnVSkDyBpqlM4lWzlhc+vAlB1NwoCjyNXrKrgAN1esgAeHIAVIzUOGCu
         hdUl6g9dyqfXgvf8pTL5Ju2D8gHYWrp8bUmyJ1OkI0p8QaUPYIdfnUOVT/GGtEG0dx5y
         PKCxFkUlHUGzIkX12nGr0dHUhV1NsxIJ+QEaENSRd2DS/K1+OLrS3FuH0EcKEBsdrXPE
         xjW6ljsHTsqw3n7wY4DbRyDBw71glTLQBWPRF1KmeftWOj2gP0rJZq7zxO0I9byJVfi/
         qyqwsO3e0HDCIk4B7p0oArS+W0O0fA+2Z27NCRatQtuucoQtd69/4Xk6iy3L8YrCiYiM
         5asQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S0kQGL1Z8bJks/onFWo7b2UmOXKnEogpEFfQxSaoZZQ=;
        b=Zcb2+jJ/GdlhP4rCELPOEmKnap9gcPic03+sWqr5rbC0jS6906V6F4U95qttIYhwZQ
         nFKxUMrsZn8zSvF0pXy7HgcigD8BOlYq077hmRB33OPDayd3pxjolC7CgEsZ3H5egohk
         M5i3KNoc2E0ngwm73U4dMsByepCxcuRZWuseNJGuhC9t+mr50U67M3w30YbYnQlCD9tG
         YC6jk3trMiG5Gz24JxSVO+lYrl9Xlx5tgpX5qn+YVI8TGKLebp8yTmqGJhi/z+k4ifkm
         HJbl9ius2wcvTszAFRT2KmG1hawN+bZe9blZfBVOQg/op0xvAsmznI+h0g2cJxvv0YQ1
         btPg==
X-Gm-Message-State: AOAM530x9z0A+HclJdHXRFc6Xj0/lGVQCd9EQZaYu9nqIHPRpldsn7EA
        aB4rSn4cUdtvwYU/jKpQ9nBzFw==
X-Google-Smtp-Source: ABdhPJzCCoxLw6D751mh3seWnzIzGBBgYKolOyGsKXgliby4JAVq7FQ2IASxq3IaDwl0pEMwyd5ZWw==
X-Received: by 2002:a17:902:7291:: with SMTP id d17mr6460922pll.141.1597083098512;
        Mon, 10 Aug 2020 11:11:38 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r15sm24531992pfq.189.2020.08.10.11.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 11:11:37 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_flush
To:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot <syzbot+6338dcebf269a590b668@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000099566305ac881a16@google.com>
 <bff14407-8ad7-fdda-e5cf-0dabc1acbb0d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a7e6d4a4-71f8-2a87-324e-31826b728902@kernel.dk>
Date:   Mon, 10 Aug 2020 12:11:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bff14407-8ad7-fdda-e5cf-0dabc1acbb0d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 10:08 AM, Pavel Begunkov wrote:
> On 10/08/2020 19:04, syzbot wrote:
>> syzbot has bisected this issue to:
>>
>> commit f86cd20c9454847a524ddbdcdec32c0380ed7c9b
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Wed Jan 29 20:46:44 2020 +0000
>>
>>     io_uring: fix linked command file table usage
> 
> There are several known problems with io_uring_cancel_files() including
> races and hangs. I had some drafts and going to patch it in a week or so.

I'll let you deal with this one, thanks.

-- 
Jens Axboe

