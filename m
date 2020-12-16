Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A152DC1E3
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 15:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgLPOLb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 09:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgLPOL3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 09:11:29 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B422EC061794
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 06:10:49 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id k8so22665433ilr.4
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 06:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I38FiREs2MvYUAmATLCdXlSOqnxZGiYMvZvKTznXIDw=;
        b=px3cE5e8qeMPLb6rB/WREm8Mpq14Uql/XoHl0P9ZFVEjHa5fbfl2+qOxL7Vpa5SJyw
         SC+gaoGq/WsUrw3aoIMx3vIOUlwbEE7hFw6bpV/Ec8q/mRZLOCkpwhcNiyAqw5Ir01O/
         EHpyYX7q6TlEnJOWShOITJTGPsOtJlBNZV5W1DwsmMeQATFuGXKbb/R2P+CxDBui1tRp
         05HO2M7J/Vfg7yU2r0pbTLo9VZdfWkEHy4L/0IrVFw1Q8JwN40IZ6Vm2+zHr2UGc0pmF
         3KefYchxedv1PGMVPqXKaYUV/iLp+/10IgOnOOchJL4Xsm5T4pdIYLFCaVnwhhIKRp0C
         ugSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I38FiREs2MvYUAmATLCdXlSOqnxZGiYMvZvKTznXIDw=;
        b=SQPzEE5MVT9g8oSZbX8BKvA8Py4eGyHOut2CEB6cegjk1NgghhMyQfnhfnvfRFy6ng
         AyQCMvSxe8+7fNbE13yRMczGnFRz2n++HVZtIUxS0dZ+JlbsLxtCtwXb1dWR73dGLgBP
         sQ2HsipGFbI5ZfmCeRYjWf65Q71kIsGNR0WqIc/XjvOmmv2I75Cysuop07begGbKtqMw
         yBxZjneCsbrFY46014QnOVbrlFO2vqnq/YuniC5fpJ/vb3WEseLCbb98AYkahgpsiqqz
         YIijXCJBwro2/3s213NNWJHfavm7UT4w0wYnv4xH6lza1Nd3VsYpZXZn5uSGQ/gobAey
         i1fw==
X-Gm-Message-State: AOAM530Tb4LsDXAhLR8lnXtm6bnGJXQHOwXBRGPywftdHd2r45zxhVlq
        gg8w0qARawcmqYyL7SINcK4VfwzZzQODTg==
X-Google-Smtp-Source: ABdhPJz/stV65lO/OtEHo/TZpdfBsXcrQDucIddLRRZHHuKqo8m4Mi/P62K0eVdbYbfW9ObHe2vLvw==
X-Received: by 2002:a92:c682:: with SMTP id o2mr46162499ilg.97.1608127848832;
        Wed, 16 Dec 2020 06:10:48 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f2sm11961057iow.4.2020.12.16.06.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 06:10:48 -0800 (PST)
Subject: Re: [GIT PULL] io_uring changes for 5.11-rc
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <917fc381-ae7d-bd35-1b4e-fc65f338b84c@kernel.dk>
Message-ID: <6e60fb23-4fd4-dc8b-e3ca-1673f1fd63bf@kernel.dk>
Date:   Wed, 16 Dec 2020 07:10:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <917fc381-ae7d-bd35-1b4e-fc65f338b84c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/14/20 7:41 AM, Jens Axboe wrote:
> Hi Linus,
> 
> Fairly light set of changes this time around, and mostly some bits that
> were pushed out to 5.11 instead of 5.10, fixes/cleanups, and a few
> features. In particular:
> 
> - Cleanups around iovec import (David Laight, Pavel)
> 
> - Add timeout support for io_uring_enter(2), which enables us to clean
>   up liburing and avoid a timeout sqe submission in the completion path.
>   The big win here is that it allows setups that split SQ and CQ
>   handling into separate threads to avoid locking, as the CQ side will
>   no longer submit when timeouts are needed when waiting for events.
>   (Hao Xu)
> 
> - Add support for socket shutdown, and renameat/unlinkat.
> 
> - SQPOLL cleanups and improvements (Xiaoguang Wang)
> 
> - Allow SQPOLL setups for CAP_SYS_NICE, and enable regular (non-fixed)
>   files to be used.
> 
> - Cancelation improvements (Pavel)
> 
> - Fixed file reference improvements (Pavel)
> 
> - IOPOLL related race fixes (Pavel)
> 
> - Lots of other little fixes and cleanups (mostly Pavel)
> 
> Please pull!

With the net branch pulled, this will now fail due to the changing
of sock_from_file. It'll merge cleanly, but you need to fix that
one up.

fs/io_uring.c: In function ‘io_shutdown’:
fs/io_uring.c:3784:9: error: too many arguments to function ‘sock_from_file’
 3784 |  sock = sock_from_file(req->file, &ret);
      |         ^~~~~~~~~~~~~~
In file included from fs/io_uring.c:63:
./include/linux/net.h:243:16: note: declared here
  243 | struct socket *sock_from_file(struct file *file);
      |                ^~~~~~~~~~~~~~
make[1]: *** [scripts/Makefile.build:279: fs/io_uring.o] Error 1

Like so:

 -	sock = sock_from_file(req->file, &ret);
++	sock = sock_from_file(req->file);
+ 	if (unlikely(!sock))
 -		return ret;
++		return -ENOTSOCK;

-- 
Jens Axboe

