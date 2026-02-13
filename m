Return-Path: <io-uring+bounces-12200-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBeMHOR9j2nZRAEAu9opvQ
	(envelope-from <io-uring+bounces-12200-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:39:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 899201393EA
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5E8763004C84
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 19:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CD3246782;
	Fri, 13 Feb 2026 19:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwHY2AYa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4215F213E89
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771011549; cv=pass; b=qX7VX62SzDEbGdnVmnz5nhbttLIrTpVdUC27r3ImOqv+4/PniTSF9XdYvdlo+y5yz0MQfOlV+t2qXrtO9CSphgS3+dXSNXwmvpuLxPMqBKGV6D9JYwitAGcj9k0e62ykaR1UL+rO+ZUioVz8WYN8dvlONxxi1x9CzrVJ+TVsb3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771011549; c=relaxed/simple;
	bh=zA2y6LjDfPmLiARSituogZ7cYHopotcjvkXLAWIdFcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LjHHjzTx+rOeb5YlYwnr1epoz80qS03dlW3bhpFjmj2kLTfBrgdX6ElQT7cMmLZtmf2ZlXMEr4pdmtGT2trLYXhvx+C6VfprEi1Ur8l4ClGc4ylYPj0hDIiAi6FUx6LFF6istPESHf9pebua9ukEYxt9deTVqbGSrWq0A2oEXsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwHY2AYa; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cb382f5c0bso138851285a.2
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 11:39:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771011547; cv=none;
        d=google.com; s=arc-20240605;
        b=QFCreZzZS/8Bmn4lL5sRRrJUd9pL1VEMgjjm8AmTO1WPBD2QmFsk7TdhYS/dWHy+8I
         /Siq/HhSyKgJOVGNoM8nx67MS0uKT/FG58a8JQfnofZFTNShmgnd0z3zR3gnvT1UAKB+
         xfsTaRzrtBGajN57ApFq2JETGj02zzwX4e7dGf3MxieEObP203/+VcA6L+ZUQCZ03+I8
         di1GKoMZAzbl4wvj8bI5N0l+dqsNGMARnft6U4W3ydLQ7MNQfDDlpY7P8GlqbS4mqFIm
         +soHMEcKOTjAdedBXPGEB+JZUflawKju5ROqgXTg/4l//2QmEEpP7okEY6otg10C46c5
         cnCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jAQLg8fKx0Ft91uWEDeN0DJzoLcwxtub+ojv94l79PE=;
        fh=OLpnJXMZvbgnjaN/CT08qkfGfSMbQvRpCe8Jwg8woaY=;
        b=Z4S6U+tCzwYrBARk+sHUbmLXWTMaqG8+LCDPckSeoOloBTDCDT8f8LL7eU6suLOOaj
         /5u3CLPdt8niP2mUIx4zsYxG7c0W7hWm8HCWCLa1TAC5u7Q9DH5GGuZW8Tr5VnBqnOCG
         LA+qJL5gGRxSInQ8QnDFFdAxbGS5EnMjrtAntFe5yhyQF7REmfJPglv9RO+vVV8RTiMq
         ZLhNduM1xx8j4/R8vOOfhYBSFfKJBjG1uTRMfF+G6sm1KeVC8eShsuZGkQbmcu42jhWL
         MVyPcTR4hiiR1g/li5TTunUd10/QDoMgDgkoBj5TkM+cSL7uZFaTW66uK8Lk7pKfBztZ
         EiQw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771011547; x=1771616347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jAQLg8fKx0Ft91uWEDeN0DJzoLcwxtub+ojv94l79PE=;
        b=bwHY2AYakN72s14H3J9a5Gig4hi6s/4qhBB0QdUdEbM7cTx5PxZEYSd2Zh88NxQEF1
         wCMOt/6U3xyzEhpcxTsWoxfGGIYWox/Dy/SFhwHTOsOrfipQ8VKeHNil3KyaEYcKglBE
         LJfRZGj/tWwIuV0oHaAcMGmjO0UJLSh9VdY5tVDbr7dGFgSqRAwlrUWbJb5wnQGlmFTi
         /cWv2fWba99z1M4ArVi4cjN8Nm9MyZeAB8Tgq+HAHpYkxTPFXx4qS9VfTpz7UvEsDKWz
         AdmSss4bpqMtxgEAvzu753Lzwna6ZJ6zOxVocYE/gAIvUuePHdAUg/0BU4trvJk5KmqC
         MBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771011547; x=1771616347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jAQLg8fKx0Ft91uWEDeN0DJzoLcwxtub+ojv94l79PE=;
        b=Ib41UYUDzWNrx7FFmLjGe2q2sp6FU0Zk2pH/UaQA0CVR1BRbR3bMKkmm7DHL9LsxW+
         l/pvTJbRiiRl1gW2D0t9xXm8gazPSLkI+8nMH8auHXs4JFJo5WTrklVIazdYTIMlKlnh
         ZLggxTwN58RC/mDybfZmK4uMzqcV+nFu9nEZZoWkUcXfQhCHRj09efugzx1/nHXkEUo3
         sLxhV4DYx/BFzjbzFFQWgvV/qtlSdXEftIrVKPnnZswgJ46w0ler/tAWULszkKxvYszK
         wYdO3L89qRCOrhMezg8SlzAoIQ43Gf42hcIIAAoNW+J3VXIv6+3QZtYtiloZig7XmUUm
         oT1g==
X-Forwarded-Encrypted: i=1; AJvYcCVfUE6vsIDgFF62BJzZd2Au4QRKpwLNcFTRvHqfJq/1B30DfVrGyIH5YCvfTeKxbSk+UwnqUZUCaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YySeZ+KvXRoQL4Dm6YnJ7PVT3V0rrl56aIRrzSiPC5QyaevUoWL
	XX5HMsPXjAnqK2YLjc8IJzykzzNJoApjQ3hlXYkPHHR/dDTUhZTfs57dBzgcDipzLA7UmRTtcbQ
	dAO9JRyXRy4Bt7ohfwmuk3QlRs25Bzhk=
X-Gm-Gg: AZuq6aJGfBiyyX/x9uKIAlKrA/cQ8ghMtkj3umtp+FPSXa9A7WatLFlkT/394E1o9M5
	mOXnDMw1wPFYPsUCT/YNcUqflApuilsWZl4H2sh6eyQvgEtMvmvRj5v42EtkPeF9BZ+bFRFe/N4
	TS4HnTi8EiyY4QxjAV78x8OUNz4p3AI6+ksQaq1D9Sos1PcCAswbAnhZycn4vQNEA5Sq7bjj4H2
	DQ408+0Bo6Z0Kf8WWF/l8Oz1LMEzO8zNqYiUEI6O7UfDUN4txOZ4/Ge9KFJuMZTTS/RPLRufW+H
	Li3IVw==
X-Received: by 2002:a05:622a:30f:b0:502:a1bc:2ba9 with SMTP id
 d75a77b69052e-506a815d2b0mr36863451cf.0.1771011547118; Fri, 13 Feb 2026
 11:39:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com> <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com> <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org> <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
 <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
 <aY7ScyJOp4zqKJO7@infradead.org> <7c241b57-95d4-4d58-8cd3-369751f17df1@gmail.com>
 <CAJnrk1b2BHwBzz+AS7x0WuJSpf98x1xGhf1ys2rm4Ffb0_5TOA@mail.gmail.com> <d9e25d62-d63c-4e09-9607-360c4a847087@bsbernd.com>
In-Reply-To: <d9e25d62-d63c-4e09-9607-360c4a847087@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 13 Feb 2026 11:38:55 -0800
X-Gm-Features: AZwV_QhRGFEot_cq7ISMfazR6KCmIaunla5EgXsb-BO16ysNIkG0m1jg441Zflc
Message-ID: <CAJnrk1Ys6_7TuUSvEvWfre0oHCT6NKqdQSHXtRERt-ktHDbMkQ@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, 
	io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,infradead.org,kernel.dk,vger.kernel.org,purestorage.com,suse.de];
	TAGGED_FROM(0.00)[bounces-12200-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 899201393EA
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 11:30=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com>=
 wrote:
>
>
>
> On 2/13/26 20:09, Joanne Koong wrote:
> > On Fri, Feb 13, 2026 at 7:31=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >>
> >> On 2/13/26 07:27, Christoph Hellwig wrote:
> >>> On Thu, Feb 12, 2026 at 09:29:31AM -0800, Joanne Koong wrote:
> >>>>>> I'm arguing exactly against this.  For my use case I need a setup
> >>>>>> where the kernel controls the allocation fully and guarantees user
> >>>>>> processes can only read the memory but never write to it.  I'd lov=
e
> >>>>
> >>>> By "control the allocation fully" do you mean for your use case, the
> >>>> allocation/setup isn't triggered by userspace but is initiated by th=
e
> >>>> kernel (eg user never explicitly registers any kbuf ring, the kernel
> >>>> just uses the kbuf ring data structure internally and users can read
> >>>> the buffer contents)? If userspace initiates the setup of the kbuf
> >>>> ring, going through IORING_REGISTER_MEM_REGION would be semantically
> >>>> the same, except the buffer allocation by the kernel now happens
> >>>> before the ring is created and then later populated into the ring.
> >>>> userspace would still need to make an mmap call to the region and th=
e
> >>>> kernel could enforce that as read-only. But if userspace doesn't
> >>>> initiate the setup, then going through IORING_REGISTER_MEM_REGION ge=
ts
> >>>> uglier.
> >>>
> >>> The idea is that the application tells the kernel that it wants to us=
e
> >>> a fixed buffer pool for reads.  Right now the application does this
> >>> using io_uring_register_buffers().  The problem with that is that
> >>> io_uring_register_buffers ends up just doing a pin of the memory,
> >>> but the application or, in case of shared memory, someone else could
> >>> still modify the memory.  If the underlying file system or storage
> >>> device needs verify checksums, or worse rebuild data from parity
> >>> (or uncompress), it needs to ensure that the memory it is operating
> >>> on can't be modified by someone else.
> >>>
> >>> So I've been thinking of a version of io_uring_register_buffers where
> >>> the buffers are not provided by the application, but instead by the
> >>> kernel and mapped into the application address space read-only for
> >>> a while, and I thought I could implement this on top of your series,
> >>> but I have to admit I haven't really looked into the details all
> >>> that much.
> >>
> >> There is nothing about registered buffers in this series. And even
> >> if you try to reuse buffer allocation out of it, it'll come with
> >> a circular buffer you'll have no need for. And I'm pretty much
> >
> > I think the circular buffer will be useful for Christoph's use case in
> > the same way it'll be useful for fuse's. The read payload could be
> > differently sized across requests, so it's a lot of wasted space to
> > have to allocate a buffer large enough to support the max-size request
> > per entry in the io_ring. With using a circular buffer, buffers have a
> > way to be shared across entries, which means we can significantly
> > reduce how much memory needs to be allocated.
>
> Dunno, what we actually want is requests of multiple sizes. Sharing
> buffers across entries sounds like just reducing the ring size - I
> personally don't see the point here.

By "sharing buffers across entries" what I mean is different regions
of the buffer can now be used concurrently by multiple entries.

Thanks,
Joanne
>
>
> Thanks,
> Bernd

