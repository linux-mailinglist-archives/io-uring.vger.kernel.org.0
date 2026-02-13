Return-Path: <io-uring+bounces-12197-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cP9zF+h2j2lERAEAu9opvQ
	(envelope-from <io-uring+bounces-12197-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:09:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0788D1391A6
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5EAF9300D4E9
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 19:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E71C27466A;
	Fri, 13 Feb 2026 19:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lilsQ2My"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A90261393
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 19:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771009766; cv=pass; b=sMgxpwDRcKVyOOiNzbOBr58ppTkJ8tE02yvKS2/m4mclawyyg/uHiTLp2K9KD1RDmzKhlFj9boWaXb8zhwMyUlJRofjoRVX0i2lyWa/R91BVyjE+hhnhfgM8aOquK8HZP+3YEgyKkNzJSFAlXS3nB8ys4Piiz4UpVkJTeHjKPlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771009766; c=relaxed/simple;
	bh=zVUNVZEhtz1zAKIlPkoMOnIshcjJh+u7Cbs5oPUruaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E6ntcB2VOgeSAXSJ9NgV5vx+e9brconn2FGw3DavWZ1/fWdOdmLul0shan5KhxyCsQVhlGTI7TJGbRGkXJcGHwGWyYwpIdRlpfLi+OUx49VkliOAC+hvy/9bEC1vgt5Zxd+WBPQzwtAml+ZKxIlIDeTcDABI65AqjG01YusIZlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lilsQ2My; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-506aa68065eso7237361cf.1
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 11:09:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771009764; cv=none;
        d=google.com; s=arc-20240605;
        b=c53P5f7z3qP9tQynpeNZMqN2BmG5VylQtwb8shSePGJSCPyhgbYmykOVPgYFobPguQ
         tMX8e8rap6gTtTcnZV1qwfsl53gVdTVlEt3P5qgXAQ5uLzggydYy88pyhJjicMAacRGI
         lnrR5am0rpd7IOokqycVuyQyhyriheb4q7OGC/BHq5BwjFVFGgzIVFMTWhk+108Ry0Ck
         RQazwyIEF9/XX/WRCZNp2MQLfnHGlJwgV0WozVPDdaap57rNZ/U+V1Q6DlSqwaGu/OOe
         cPqoPQ12OaOBMH9oApiQD4pYb8k8BzbK+/R02hmW82WQqEp365EWue0hft5LPTc8bSvN
         rfcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QS2M3KAztoqucCJzQWm9xa6Cgpv3hSDX6ecO7H+gY2A=;
        fh=9YTlcYLjFuVpWnPmHQF5RFoGLXELuPBGvBtdG742CIM=;
        b=WHvGGy3GIhAvNhZ36vM05iXkYm7tYrRKZF6oKV0yUFS5BqnTJr22zWtq7dy7/KBrwa
         z8dEHqzhvWwzzUN2VeZ1VYVt0kVsiIxqLSJfbXH355Q/yCUxqwi4JGrlT2tRphcl6FlM
         3GkQ3qiaE0wSf6vIsIcnvqVpZYSfnC8SY1uAK7Wgi2zw4U33SLBNxe+PFDyeVtDFIXAM
         xDi9+2An1CNaDTtObM1H2mjLdIx2awrDPaHj04IpMKbpJAmgNIl5RZnU5ZXYSjtgi76u
         uu2vTeOgtv7UzAsmDpXoJaCwQLwn7m56b/loPu4clgX+uy+CL6GkKSszSp0wp57huWMp
         ZJSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771009764; x=1771614564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QS2M3KAztoqucCJzQWm9xa6Cgpv3hSDX6ecO7H+gY2A=;
        b=lilsQ2MyM9/7oY0+o5sVAmZBe2ElcafoByPB8a3StlTPlNUhSYb7HhBTqTS9WqxUZO
         ku1rHLbZ4+waL2MCz4Ytxnba1AuaVPbkeT9djWK529eZU5d07s62PWY8SQTHZ5qbUTZr
         s1RBOpOspzMO79YD1tFHiKZkYRv1hec1zsYlLaP4MBxIdiMS5RShnpkYpzkgvwe3tER+
         t9/XNqNdcJVoLUUBS6e82XZLklLPJkAQFDF2sGrd77O74B7FuJqXKHqE/EKlUiLu1W8O
         NKe6YZmMyohdpQ8SiI4WU0SbKinKJO7Dlda7JvZTTqz17MvbhL3cpcSn26zrN1ePkYpc
         hJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771009764; x=1771614564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QS2M3KAztoqucCJzQWm9xa6Cgpv3hSDX6ecO7H+gY2A=;
        b=LxDIVRfJoumMsMvto+4dnX6WK/wyNNtJsCoGjTCYxVj+wPqAf+pIB8r5v9SQfIWKUd
         gRPkeyq+7HcwW34ew8A90kNWdah+if4EGQvQr5y1Zy04FauV3Ig0iDeM4itLDaXbwfsw
         EToQyKRURf8HYd1KOS1AaEsz8X4VCCh47Ljv+HemOszDPnmBWE41L0hw3xbbrJ3Fg3VC
         xV4O0O5IS641x07v2+HRcqx07xNPfhiidi4HJXm2YqD+ufsyuxuGk1Qlv6EsRNVatHv3
         XKavSwK1ExIQeiGj8yv6kFIGBxXgC9ihJ69HVvEzUCYcY27sX6etnQ+8QQoyHbza9Xxc
         Ywtw==
X-Forwarded-Encrypted: i=1; AJvYcCXVh+0SiDSLrqxqXdD5nmeQjGwuEc/PBvLyNo0BM4ySgxpSHDDWkp31e0p5Rq3tnRmMC92YMB0kVw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7VnUrIGMkA+2qIrnJKIb+12P43jgSKIzyRp3PKo0yTN5AKJFR
	DURWIa6pd3oU5qrRj0XHT3uWv5aNkujcSpgXCnLFphaluop6XOL+9ISdgEwf6OS5FWsKRU/zGvN
	cLLO8WA6pOQJiE75TpfAqCsPsOkjLfeQ=
X-Gm-Gg: AZuq6aLxSC5fACAlXDFPhXiUBMyFv/OemVzhccZ9b8lI8z6ZHsgdJl/2czAU65pys1e
	kQSuXyM9WEz/AeWynKp0j+oyuNUHHdUXpEiKnpFBLboZBPaoWGRlFRV+ZTFApaWc+59BrdrGZ04
	CZHxYNadhd7WLkjOLPJcZqdMFuLUsGJl0tkdxGSsJVlfu+W+4P/FZgyHjc5XDf/OD3mLyzknh/V
	NOwajlo/hryUQMqn0roETrIFFi3ZfyQXId6KCvGk/g3X+vfPEi04AoVxDmuG5sp8ZKHh6tvA4ir
	XyBA3A==
X-Received: by 2002:ac8:5ac9:0:b0:4ed:a6b0:5c39 with SMTP id
 d75a77b69052e-506a836443fmr38528111cf.63.1771009763940; Fri, 13 Feb 2026
 11:09:23 -0800 (PST)
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
In-Reply-To: <7c241b57-95d4-4d58-8cd3-369751f17df1@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 13 Feb 2026 11:09:13 -0800
X-Gm-Features: AZwV_Qh3vzmcZHHFrk5tmRY-L42DG_4kEaGwxKU2xKfVbjOIkj69uMfOnC1kUFU
Message-ID: <CAJnrk1b2BHwBzz+AS7x0WuJSpf98x1xGhf1ys2rm4Ffb0_5TOA@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12197-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0788D1391A6
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 7:31=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/13/26 07:27, Christoph Hellwig wrote:
> > On Thu, Feb 12, 2026 at 09:29:31AM -0800, Joanne Koong wrote:
> >>>> I'm arguing exactly against this.  For my use case I need a setup
> >>>> where the kernel controls the allocation fully and guarantees user
> >>>> processes can only read the memory but never write to it.  I'd love
> >>
> >> By "control the allocation fully" do you mean for your use case, the
> >> allocation/setup isn't triggered by userspace but is initiated by the
> >> kernel (eg user never explicitly registers any kbuf ring, the kernel
> >> just uses the kbuf ring data structure internally and users can read
> >> the buffer contents)? If userspace initiates the setup of the kbuf
> >> ring, going through IORING_REGISTER_MEM_REGION would be semantically
> >> the same, except the buffer allocation by the kernel now happens
> >> before the ring is created and then later populated into the ring.
> >> userspace would still need to make an mmap call to the region and the
> >> kernel could enforce that as read-only. But if userspace doesn't
> >> initiate the setup, then going through IORING_REGISTER_MEM_REGION gets
> >> uglier.
> >
> > The idea is that the application tells the kernel that it wants to use
> > a fixed buffer pool for reads.  Right now the application does this
> > using io_uring_register_buffers().  The problem with that is that
> > io_uring_register_buffers ends up just doing a pin of the memory,
> > but the application or, in case of shared memory, someone else could
> > still modify the memory.  If the underlying file system or storage
> > device needs verify checksums, or worse rebuild data from parity
> > (or uncompress), it needs to ensure that the memory it is operating
> > on can't be modified by someone else.
> >
> > So I've been thinking of a version of io_uring_register_buffers where
> > the buffers are not provided by the application, but instead by the
> > kernel and mapped into the application address space read-only for
> > a while, and I thought I could implement this on top of your series,
> > but I have to admit I haven't really looked into the details all
> > that much.
>
> There is nothing about registered buffers in this series. And even
> if you try to reuse buffer allocation out of it, it'll come with
> a circular buffer you'll have no need for. And I'm pretty much

I think the circular buffer will be useful for Christoph's use case in
the same way it'll be useful for fuse's. The read payload could be
differently sized across requests, so it's a lot of wasted space to
have to allocate a buffer large enough to support the max-size request
per entry in the io_ring. With using a circular buffer, buffers have a
way to be shared across entries, which means we can significantly
reduce how much memory needs to be allocated.

Thanks,
Joanne

> arguing about separating those for io_uring.
>
> --
> Pavel Begunkov
>

