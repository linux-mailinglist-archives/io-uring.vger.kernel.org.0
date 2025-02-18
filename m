Return-Path: <io-uring+bounces-6511-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7A6A3A7C4
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46EF33B320A
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 19:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 138801E8355;
	Tue, 18 Feb 2025 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NzKg3CHY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281311E833E
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 19:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739907555; cv=none; b=PvSKqbXd7xxXmf++2Mh1fOk/CNb4JKEOYcyuHb5WAmQIb+bM4jgcK/rgNgIXn9uqaf8Dbnq+zOyTKhCvSUtQ5vPdjqoz1iDUO2rM3gD6I/HXazh+BYLzbitAC5OS7ABq9kwfPvAm/AfDwBJVjMy6avNTKwQpD0yFVx92iQOw2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739907555; c=relaxed/simple;
	bh=Q7LTT7Wm9UqhVFBc3F/J/X1Aop+TluuU8hYd8w4e02s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9MFDN8gOprBabI7wdwG3Kuwz24cLa1Ft5ovzwyYNlJBf38Xws7tA9KkP18ZyvO/OF/f2ZnAUI6FVX0S5jnn+iQht2U8yzcsb8T5sEQpnXlvKEbYjuZSr5tJJ+XcE4LXWmPCoFxTrILk/FErdGo3SR7JWcbyds6cOvOWoKVF3SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NzKg3CHY; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-220f4dd756eso79789975ad.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 11:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739907552; x=1740512352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7LTT7Wm9UqhVFBc3F/J/X1Aop+TluuU8hYd8w4e02s=;
        b=NzKg3CHYxFEl7n2pf4OZA338HDu6My9cRieEcDB8clYpcTTqewgti+KFXINcmVdbAy
         n9999NMv0t2ph7zSsHGU3EReOtuLVE+dGH1RXmN5YSXEnDzuw2Tj0+bSxm6Fx+I8bvRX
         Z+bzF7XMaQd498801RvKYrrfErQ38vwFwGsbp81T1+u/sNBqj35GYXVPsF7WCV9cQFXJ
         6VfY6NZNhsYQbWc44QBOE2ARfpXkn3p6BcJpRQCkccGJf2n5LQXOZt1Lt8Ew9nrUIVR9
         JApCyYqaqlO7EAX8aQfZE8ORSFNB3erxAlW1eLn2mywhRgVRvM659b1ZNxkyrZA8SQTY
         NgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739907552; x=1740512352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7LTT7Wm9UqhVFBc3F/J/X1Aop+TluuU8hYd8w4e02s=;
        b=VtLFmUcBVndceySIiY7gVjkWjUmuybpsA/PgTSzF9VT11rgQT6IJqOFGwyColM1E1a
         X4fGoyPK3/HdRK/4nEvj8vPsMaCOGOF6O1UiI5iZhSTEE0c8MGD1yWtLpyAmVGrTE+D9
         eDSCoAR0OjnjJcPAjcDoQai7RQ0G8e6IoOCO/PBcWTEZ4Unowx0cvEgJpa/QddaCUbwX
         K8mD6A/u/FjqH+zo+cqe4hfl7bCKoDhx64NcQCwTfp6YLaDSGmiffuX4+2FeKi9g3dyN
         cYM5iWl0ENAqUtPsoI1NXofW8rT3exuAKERG4fdkmnm2l+11qe8G2PzMz8RX3sSJAqCl
         k4jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaJl5v+aNaGsXKIr+7MU+Ofh6QltmXDuHeN0GElaljUUF3rgqBuIwPOOtxF6MSolB7XG64boyUuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YymjWPZAvB6dUuMb8wHFatdIwcDosUHFXF7n2qO5XRpb/1BV3HQ
	GHPZ6ZYNz240cbvOtgRiHFlBXX/Yk1i4thaqt2cFGgaXqP8WngSHxZfrMaBnH+2/tGW716c5F5L
	5gnEgQ7FRfXw7T+Ih3GMcJNVSIRhUoCCa
X-Gm-Gg: ASbGncsm5rIicmip2fKU7q2Uj5hH3qv6au/PBa8qx7GenUuUXrXCDCTDTj18CkAzwJQ
	wXIAlaz/BusS5hTOAS461echJM/T0/1K9qxxIubKXRTyr3L0apjhkq0bDHnHMUaxaNkGMqmP0u8
	aUJ0QKp0LmZGwxcQrXE5MNO+/FbDHQ0yr8+xpJ5rUXefGhGDhK8h/KWi+mNtU74z91j1UBm2qVZ
	eBjHbrGjjmvm2dNF2O2fhQo917vRy7z91kphRwGxD/AgYQvlB5uKgWLxHC/ekat9sqGj6VKeUy3
	C5GasnY8wRbsUxiPW2AY9s7mFTuXLv4hgNpsDyQ=
X-Google-Smtp-Source: AGHT+IFNIdSYM7+WXsZiOT5Xx7TOf2qWhmhr/pQrIfJUySaFtdz6Vw0allzoc6spDrqb+wnG2qnPKTEW+okJ
X-Received: by 2002:a17:902:f54e:b0:220:ca08:8986 with SMTP id d9443c01a7336-2210402d6b2mr277167805ad.22.1739907552238;
        Tue, 18 Feb 2025 11:39:12 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-220d543c7edsm6090745ad.127.2025.02.18.11.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 11:39:12 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [10.7.70.36])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 89B0734034F;
	Tue, 18 Feb 2025 12:39:11 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id 78825E40152; Tue, 18 Feb 2025 12:39:11 -0700 (MST)
Date: Tue, 18 Feb 2025 12:39:11 -0700
From: Uday Shankar <ushankar@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io-wq: backoff when retrying worker creation
Message-ID: <Z7Th3+O38yNi7fZU@dev-ushankar.dev.purestorage.com>
References: <20250208-wq_retry-v2-1-4f6f5041d303@purestorage.com>
 <Z6+sXQrSYRyGEScf@dev-ushankar.dev.purestorage.com>
 <ea9a9431-8e8f-48c0-82b9-8b1abd44cc0f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea9a9431-8e8f-48c0-82b9-8b1abd44cc0f@kernel.dk>

On Fri, Feb 14, 2025 at 03:31:54PM -0700, Jens Axboe wrote:
> I'll get it queued up. I do think for a better fix, we could rely on
> task_work on the actual task in question. Because that will be run once
> it exits to userspace, which will deliver any pending signals as well.
> That should be a better gating mechanism for the retry. But that will
> most likely become more involved, so I think doing something like this
> first is fine.

How would that work? task_work_run is called from various places,
including get_signal where we're fairly likely to have a signal pending.
I don't think there is a way to get a task_work item to run only when
we're guaranteed that no signal is pending. There is the "resume user
mode work" stuff but that looks like it is only about the notification
mechanism - the work item itself is not marked in any way and may be
executed "sooner" e.g. if the task gets a signal.

This also doesn't work for retries past the first - in that case, when
we fail create_io_thread, we're already in task_work context, and
immediately queueing a task_work for the retry there won't work, as the
very same invocation of task_work_run that we're currently in will pick
up the new work as well. I assume that was the whole reason why we
bounced queueing the retry to a kworker, only to come back to the
original task via task_work in the first place.

I also thought it might be worth studying what fork() and friends do,
since they have to deal with a similar problem. These syscalls seem to
do their retry by editing the syscalling task's registers before
returning to userspace in such a way that the syscall instruction is
executed again. If there's a signal that needs to be delivered, the
signal handler in userspace is called before the retry executes. This
solution seems very specific to a syscall and I don't think we can take
inspiration from it given that we are calling copy_process from
task_work...


