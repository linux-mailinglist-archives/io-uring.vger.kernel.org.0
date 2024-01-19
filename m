Return-Path: <io-uring+bounces-431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA77832E4B
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 18:41:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BA55B21764
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 17:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A2255E73;
	Fri, 19 Jan 2024 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OBpVHnTF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501F4C3D4
	for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 17:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705686073; cv=none; b=jdk6436u2e7YGs9cwjJFbWwG6rutQgl0NjEP5BvKyCOeCK2g6bzOartBtY/6iZX8+z2bxcDIymYYmbKHh86vcicfgFb7zGQcUV1mSNEzcymTIwrZBiUmnK2YFKz4LK/jUi8fXkWkQ0AwsmKpNxvMLy6H6y1hKIeAdng1sZTXOzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705686073; c=relaxed/simple;
	bh=TSiAoITa+M2mAlzOu+O+IwZ101ZG+8Ntl6vKvS5LQPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WQ4+3+h03CaPDKzWYPVsSQIsVxgjgI7SBQ3/kmLMnB0a7+oCwugy07NnzUuFZPOF7fh5rQs4u8rkYsAIdJgNXFH3E4LoFAuFbMjn1ARL+6hz+pofKd3moimObgimoOLQMTdc05F2E/txA2kH91ba/Y6IOAyZvLyPrconEfavidE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OBpVHnTF; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bed82030faso14645239f.1
        for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705686070; x=1706290870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/le8kuI8ZSrDfjIjX1HxI1ueVfhTAOLfRLakiPaaFrs=;
        b=OBpVHnTFnjxQig5rSi+DH0VnpmLJ4ZuPfxN8GRknu24bNTEiL583RmgWU6e78oDxEZ
         SHqFVQvRxuNq/EaoWdBuDL0SFxOkV+jr3FxBzNKUsS4CXZEbBUhlrpo7eBnrFyU7OUJF
         ie1qJws3phRYcr6UbtunbntpHx9y/8m0ZI3piQV+c9zTVmC87XFl32a38zp2Z6vHBwq+
         bB4tc/3RCJBWSzjhsDcPugN0K5cVhhGto3rFHjT8IbtSi5e/3YHKQtoC855uM21ApmW9
         xmax1xjYC+Y7hP1XBINuE9vEQRUzVWertM66EkSHRA6tMT7TUJkuO+dffjRmhSx2nn1x
         VP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705686070; x=1706290870;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/le8kuI8ZSrDfjIjX1HxI1ueVfhTAOLfRLakiPaaFrs=;
        b=wRYmSz8KWHLqPph0AMxX44B1WzYPAglU4b+IW+AH/0Z4xSZeOD+OEDfPWheipC1pL0
         mSQV9aToPDC9q2JmP5bvbYWo3JkdBYUyE28ukmOJ/ZFkm9T4yQhJPP5rB1mYSdXpGJkb
         F2+BYEhWlYs8LGIFr2iF31ffS+ecWoGks1RS2Lipr9JH92kMVeiZ/99dsk/tHbHgVzIu
         6TnULWNmd3+6/0TokH/tp5lvd1gQ36RxSd1c8iStKLZw/AZswq/sdX2DOgIb392ovGvc
         E6SusieMvxeWJQ3SL/JZBRRZtcrKw49ox68epv30lqJ9y71qfjlRXW+V0Cunl9KeHUvV
         rhaw==
X-Gm-Message-State: AOJu0YzH3bJQ8bmvmCpbliprzSZWXQxDA8t4MD1bz2vhL8q+x0qlMXP7
	cAPX+cZ0/HdsuXq6NmhAuWoVCGm1hm5MWWJyhuTzthMyDySNlxZ3fkAZKKf16xA=
X-Google-Smtp-Source: AGHT+IHmQ4RjGwRzYrYp5AA9gZKB0mysqf90X2GLnAyMw7GmqWhEvBlrizk4F8G1GkLHrhI58VIqLw==
X-Received: by 2002:a5d:8942:0:b0:7bf:3651:4c6d with SMTP id b2-20020a5d8942000000b007bf36514c6dmr66915iot.2.1705686070615;
        Fri, 19 Jan 2024 09:41:10 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g1-20020a05663811c100b0046b451e7b57sm1646469jas.45.2024.01.19.09.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jan 2024 09:41:10 -0800 (PST)
Message-ID: <610f91a7-9b5a-4a07-9912-e336896fff0c@kernel.dk>
Date: Fri, 19 Jan 2024 10:41:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: IORING_OP_FIXED_FD_INSTALL and audit/LSM interactions
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
 linux-security-module@vger.kernel.org, audit@vger.kernel.org,
 selinux@vger.kernel.org
References: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>
 <80b76dac-6406-48c5-aa31-87a2595a023f@kernel.dk>
 <CAHC9VhQuM1+oYm-Y9ehfb6d7Yz2++pughEkUFNfFpsvinTGTpg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhQuM1+oYm-Y9ehfb6d7Yz2++pughEkUFNfFpsvinTGTpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/24 10:20 AM, Paul Moore wrote:
> On Fri, Jan 19, 2024 at 12:02?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/19/24 9:33 AM, Paul Moore wrote:
>>> Hello all,
>>>
>>> I just noticed the recent addition of IORING_OP_FIXED_FD_INSTALL and I
>>> see that it is currently written to skip the io_uring auditing.
>>> Assuming I'm understanding the patch correctly, and I'll admit that
>>> I've only looked at it for a short time today, my gut feeling is that
>>> we want to audit the FIXED_FD_INSTALL opcode as it could make a
>>> previously io_uring-only fd generally accessible to userspace.
>>
>> We can certainly remove the audit skip, it was mostly done as we're
>> calling into the security parts anyway later on. But it's not like doing
>> the extra audit here would cause any concerns on the io_uring front.
> 
> Great.  Do you want to put a patch together for that, or should I?

Either way - I'd say if you have time to do it, please do! Probably just
include the REQ_F_CREDS change too. FWIW, I'd add that in
io_uring/openclose.c:io_install_fixed_fd_prep() - just check for
REQ_F_CREDS in there and return -EPERM (I think that would be
appropriate?) and that should disallow any IORING_OP_FIXED_FD_INSTALL if
creds have been reassigned.

>>> I'm also trying to determine how worried we should be about
>>> io_install_fixed_fd() potentially happening with the current task's
>>> credentials overridden by the io_uring's personality.  Given that this
>>> io_uring operation inserts a fd into the current process, I believe
>>> that we should be checking to see if the current task's credentials,
>>> and not the io_uring's credentials/personality, are allowed to receive
>>> the fd in receive_fd()/security_file_receive().  I don't see an
>>> obvious way to filter/block credential overrides on a per-opcode
>>> basis, but if we don't want to add a mask for io_kiocb::flags in
>>> io_issue_defs (or something similar), perhaps we can forcibly mask out
>>> REQ_F_CREDS in io_install_fixed_fd_prep()?  I'm very interested to
>>> hear what others think about this.
>>>
>>> Of course if I'm reading the commit or misunderstanding the
>>> IORING_OP_FIXED_FD_INSTALL operation, corrections are welcome :)
>>
>> I think if there are concerns for that, the easiest solution would be to
>> just fail IORING_OP_FIXED_INSTALL if REQ_F_CREDS is set. I don't really
>> see a good way to have the security side know about the old creds, as
>> the task itself is running with the assigned creds.
> 
> The more I've been thinking about it, yes, I believe there are
> concerns around FIXED_FD_INSTALL and io_uring personalities for LSMs.
> Assuming an io_uring with stored credentials for task A, yet
> accessible via task B, task B could submit an IORING_OP_OPENAT command
> to open a file using task A's creds and then FIXED_FD_INSTALL that fd
> into its own (task B's) file descriptor table without a problem as the
> installer's creds (the io_uring creds, or task A) match the file's
> creds (also task A since the io_uring opened the file).  Following
> code paths in task B that end up going through
> security_file_permission() and similar hooks may very well end up
> catching the mismatch between the file's creds and task B (depending
> on the LSM), but arguably it is something that should have been caught
> at receive_fd() time.

If there are any concerns, then I say let's just explicitly disable it
rather than rely on maybe something in the security checking catching
it. Especially because I don't think there's a valid use case for doing
this, other than perhaps trying to bypass checks you'd normally hit.
Better to err on the side of caution then.

See above for a HOWTO, if in doubt.

Thanks for looking into this!

-- 
Jens Axboe


