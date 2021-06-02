Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CC5398411
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 10:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhFBI2p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 04:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhFBI2p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 04:28:45 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8395FC061574;
        Wed,  2 Jun 2021 01:27:02 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id z137-20020a1c7e8f0000b02901774f2a7dc4so893695wmc.0;
        Wed, 02 Jun 2021 01:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CU0B/oJqWatyP0iZPnko3W/2+Dczj4WeybZjMPNiDQQ=;
        b=rKx8sgq/rksoQjxuVTAKCHOfo2duG70cbNLuuSluZsvBLfiYMJtrJSrGjKppMtlVJK
         RAGPaqCXs/QgB3CY4i1rV7Emto/AFXxMeQUI9OeCaP/UnGdIDZ8M3M0nOL6thFM9s9tv
         kBb7C6pH0YzsalcmK4FytfGrf2BU9jTqeIvBqDqSo5DbmI+/LbSdr96vK3scCXH5fFmm
         GwpSaX7wkmczKYhMeoidYZPTn+jHwUp5i+5QGzst1vDZqrkCEtk3WugJ1t9LdVVfnOzS
         TiFOLBlqdIi4A15XeAS1npIJQR/YM5ZgwWiXNJPDhxbAGozSCrc4a1ECzZcYbcDks8fd
         gePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CU0B/oJqWatyP0iZPnko3W/2+Dczj4WeybZjMPNiDQQ=;
        b=hDxdD5VZnVj2tGT7g4pUOLqC7bYyvyuiceWaClBkB+0SrrrWg6soiSnXBiD36DgFId
         soGa53AGyHqzPY4AK+oTcZ6P/c7889mcew00F7wKW8r4KETmiOLVUyts2/3EPL8DbQkx
         0yEv/8iiPxCPCKiTNnG/F2wIEy8LTJ6ViFu1T2k517WzCBCxryoXuDEsduQk2kIZNbIT
         MDwzMS+1vud5lC9APvbSWRSKLQj4Ms/nnRIqSITcLo0jNp3NFOLfGlW7ZQtZrDi2ZzPJ
         i2/fsAwJicVnqBeM4p7bWf7kbEg19gVhHI5n8RQQtjvHRdNNRGLsB/KCOD+57lG6uuAA
         kPNg==
X-Gm-Message-State: AOAM533QmNpvDySkwnq0EtkTe9QUCXACRrYQBKvf9bt20Yz/FRSDfmx0
        nzAdKuOGFFQ74raBpgYnM9M=
X-Google-Smtp-Source: ABdhPJwvZTlPfMn4KfCZxEL6JOqJss24Kw5hd2byShk3vARpVOt44/VQKL7R2Fd+bHQ8mGGIyyYhbA==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr3746995wma.89.1622622421178;
        Wed, 02 Jun 2021 01:27:01 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id p187sm1942070wmp.28.2021.06.02.01.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 01:27:00 -0700 (PDT)
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
 <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
 <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk>
 <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
Date:   Wed, 2 Jun 2021 09:26:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/28/21 5:02 PM, Paul Moore wrote:
> On Wed, May 26, 2021 at 4:19 PM Paul Moore <paul@paul-moore.com> wrote:
>> ... If we moved the _entry
>> and _exit calls into the individual operation case blocks (quick
>> openat example below) so that only certain operations were able to be
>> audited would that be acceptable assuming the high frequency ops were
>> untouched?  My initial gut feeling was that this would involve >50% of
>> the ops, but Steve Grubb seems to think it would be less; it may be
>> time to look at that a bit more seriously, but if it gets a NACK
>> regardless it isn't worth the time - thoughts?
>>
>>   case IORING_OP_OPENAT:
>>     audit_uring_entry(req->opcode);
>>     ret = io_openat(req, issue_flags);
>>     audit_uring_exit(!ret, ret);
>>     break;
> 
> I wanted to pose this question again in case it was lost in the
> thread, I suspect this may be the last option before we have to "fix"
> things at the Kconfig level.  I definitely don't want to have to go
> that route, and I suspect most everyone on this thread feels the same,
> so I'm hopeful we can find a solution that is begrudgingly acceptable
> to both groups.

May work for me, but have to ask how many, and what is the
criteria? I'd think anything opening a file or manipulating fs:

IORING_OP_ACCEPT, IORING_OP_CONNECT, IORING_OP_OPENAT[2],
IORING_OP_RENAMEAT, IORING_OP_UNLINKAT, IORING_OP_SHUTDOWN,
IORING_OP_FILES_UPDATE
+ coming mkdirat and others.

IORING_OP_CLOSE? IORING_OP_SEND IORING_OP_RECV?

What about?
IORING_OP_FSYNC, IORING_OP_SYNC_FILE_RANGE,
IORING_OP_FALLOCATE, IORING_OP_STATX,
IORING_OP_FADVISE, IORING_OP_MADVISE,
IORING_OP_EPOLL_CTL


Another question, io_uring may exercise asynchronous paths,
i.e. io_issue_sqe() returns before requests completes.
Shouldn't be the case for open/etc at the moment, but was that
considered?

I don't see it happening, but would prefer to keep it open
async reimplementation in a distant future. Does audit sleep?

-- 
Pavel Begunkov
