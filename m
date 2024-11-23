Return-Path: <io-uring+bounces-5005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 830B49D6931
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 14:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF437B21AC0
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 13:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FEF1EEE6;
	Sat, 23 Nov 2024 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="aXvwhWgi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EF0185B72
	for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732367378; cv=none; b=adZWs51u+ATHNLGsoQRtLak/iEt/cmr8pPbao/ly5OyaFx8RUGF6wXEO04TD7qVTZ6GS2hg8TQlu2vzSkEvPY3zWgJaz6kWvic+gD+DTgp9rL/McRdeYzA90oZtVDyKbW1Tn2jkyxfQV7EOMtYLtgyIitS4NirjLNXejk9ySYeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732367378; c=relaxed/simple;
	bh=cFHTZsyHjeipydo3w6s8MY+BuZDLN/iw6QtX3hfM0QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hPyzUxM23X4cmiK2Ag0U5zuJeFlU8pJNEhP1xWV5NyBq1zUDyvvg9pLydXzTBZ6ebWbkGXWvRqjXmR+R/3aEQxLDXors5xC7/jlngyGTxceXYolbHZXc86CO9USxcMsK2RBMEAl7TmizJrXlLXwFsoM4Sl6Dmv+wgGuRf/8Info=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=aXvwhWgi; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-46096aadaf0so19091401cf.2
        for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 05:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1732367375; x=1732972175; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nwjn8ShKFOcX5C5BheoU0O4GenhfSSBb9I7QpKsITtA=;
        b=aXvwhWgixfTGlK4ZmFvKLO9dJADNb+QXeIsqrUmaZVY7UfkRu/BctSFgJ8+aJ3AZBc
         khOlRdnmppoODc3ITO/xtAqsKaTODSkHFl4ksn8XBkwsWrh/lSUe2xkfQQmtSGhorFxx
         tZ3GYb3Nfiu/JEuZHCzXAAvPQj1M5xPbH71vw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732367375; x=1732972175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nwjn8ShKFOcX5C5BheoU0O4GenhfSSBb9I7QpKsITtA=;
        b=BGNpXwvzNbmlfVADNzrCT6XnEQrvjofIBT8TkySEoHpvf6xdwsP0HnA3QDFGeXuf6K
         UdfJV+0aT9/iKNkzqbBhBC62nIA3OIya8UjgL7AC8FldL3ObXHW9nDIWFX4CU3Y0FH38
         RGveWSHWAjsT0Bb/0ZflqH6LHKB9WjYjVKV5XXMr/FXFa0DGTvcJOGnUNGJnZLo0klhC
         J9yRx0/uPvRqMXpfEt4JGBPrtnPgZHMq1ZuLZXcxttTVivQXzb5wrR8tvd/JTQqEhP20
         IKr9NKkqDmGI4ZMBWWJp0ZX8D+uGAUAWdRYNHLmFuYsCj8mdgkr3DMgXC31oibEgrcqf
         g78w==
X-Forwarded-Encrypted: i=1; AJvYcCWoL8L45oOlSCfu/eJjgmQTtzBnFmFioPH9kL5IPWcnEMtOag5KKpHuZGhHTEFvhOkLe/xnWPNRYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcQVkG0khEjE9XIqyHng4lnAjtcfj+T9I3zqO/1YB637Es8NQr
	VtAaTCTVM7xHC0LXKUfgO2xJc3Q51BpoXXgEG2L4A6TnYgefjWD6pC6sMCvSQZqk7ra7VKH+sdU
	15QeFn6BzJ8RNBmBPjsnKm4hwXMy1lkI6pik1vg==
X-Gm-Gg: ASbGncuPAMo5+/Dd2Sf7ob907AAn5dHtHluklEQ31YnyNc6GRmbAyw4w+/SdQAZQxY7
	wzaE+H6IFPArQzff/H0JgHu4SQ4Cvpxi+4A==
X-Google-Smtp-Source: AGHT+IHvnC/a2xW3Q3klkTHdR9rS8s5K/zPgxzJX6JSdpaRAc97xP/gUZymSqhT5s2mkoav2T/UwWjVigUoY/FdMnZU=
X-Received: by 2002:ac8:5815:0:b0:463:1677:c09 with SMTP id
 d75a77b69052e-4653d5cd228mr78272881cf.23.1732367375658; Sat, 23 Nov 2024
 05:09:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com>
 <20241122-fuse-uring-for-6-10-rfc4-v6-6-28e6cdd0e914@ddn.com>
 <CAJfpegtih77CpuSQAOkUaKRMPj44ua65+_MUMa3LqgYjLFofqg@mail.gmail.com> <e1f3cbf0-eedf-41a9-9689-5eda56e06216@fastmail.fm>
In-Reply-To: <e1f3cbf0-eedf-41a9-9689-5eda56e06216@fastmail.fm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Nov 2024 14:09:25 +0100
Message-ID: <CAJfpegt=CxhYSyxWVBAWnf2S926Vj+1yEF_GPkOJYRMN_XbkSQ@mail.gmail.com>
Subject: Re: [PATCH RFC v6 06/16] fuse: {uring} Handle SQEs - register commands
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 23 Nov 2024 at 13:42, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
>
>
>
> On 11/23/24 10:52, Miklos Szeredi wrote:
> > On Fri, 22 Nov 2024 at 00:44, Bernd Schubert <bschubert@ddn.com> wrote:
> >
> >> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
> >> +{
> >> +       struct fuse_ring *ring = NULL;
> >> +       size_t nr_queues = num_possible_cpus();
> >> +       struct fuse_ring *res = NULL;
> >> +
> >> +       ring = kzalloc(sizeof(*fc->ring) +
> >> +                              nr_queues * sizeof(struct fuse_ring_queue),
> >
> > Left over from a previous version?
>
> Why? This struct holds all the queues? We could also put into fc, but
> it would take additional memory, even if uring is not used.

But fuse_ring_queue is allocated on demand in
fuse_uring_create_queue().  Where is this space actually gets used?

> there you really need a ring state, because access is outside of lists.
> Unless you want to iterate over the lists, if the the entry is still
> in there. Please see the discussion with Joanne in RFC v5.
> I have also added in v6 15/16 comments about non-list access.

Okay, let that be then.

> Even though libfuse sends the SQEs before
> setting up /dev/fuse threads, handling the SQEs takes longer.
> So what happens is that while IORING_OP_URING_CMD/FUSE_URING_REQ_FETCH
> are coming in, FUSE_INIT reply gets through. In userspace we do not
> know at all, when these SQEs are registered, because we don't get
> a reply. Even worse, we don't even know if io-uring works at all and
> cannot adjust number of /dev/fuse handling threads. Here setup with
> ioctls had a clear advantage - there was a clear reply.

Server could negotiate fuse uring availability in INIT, which is how
all other feature negotiations work.

> The other issue is, that we will probably first need handle FUSE_INIT
> in userspace before sending SQEs at all, in order to know the payload
> buffer size.

Yeah.

Thanks,
Miklos

