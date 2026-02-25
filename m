Return-Path: <io-uring+bounces-12425-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EKpEMxiJn2nMcgQAu9opvQ
	(envelope-from <io-uring+bounces-12425-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 00:43:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 782B419EF25
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 00:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F194730630BF
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 23:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD128385516;
	Wed, 25 Feb 2026 23:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmnsGVRk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A10038550C
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772062965; cv=pass; b=qx1fskIC7bN4xqinOw7TE4di+uMsw279Ovf6By9+QyKPCB1yUkCGQKNofDSJHQraBsMbDV1z1eCpgXuWvTwJtZ3fhrrMoewC+ChzTQAwluieJ1Vr5CcNpKrUWhAF2h5ptoWXL3byUFFRplxAs5TW5sny+pY60LW+Z6gR8DlM7Yw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772062965; c=relaxed/simple;
	bh=hPQ5WkytrCUnl0p7D9sItJgtY1MIrl6gTsoJYhmmK7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bl108LTLz/f61mdJtmQYgNVE5Wa+hDQmRw1ELO+h4VeOE/78/X8UrlXJZMRtL0OD9FZXtvovECo/82g+KrZEbY9BQUeCy4sMh4HpB23GE2wcFPLsR9gbRDqetn3S0cQFFzugVTvtJZZ8J7X1udG6HvR/8DasLhQNLVjknBb0f50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OmnsGVRk; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899b95707afso3744786d6.3
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 15:42:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772062962; cv=none;
        d=google.com; s=arc-20240605;
        b=ayOAODJbBkbztvWpCay2q3MHaYGcYVURmKUAQ4LMPi5JlWeiwaliVozRaUN1cgnxsL
         cVnfTy4y1SvucW1mUWbA53r/SfYxnFcqdkN2qU6tl2PAUz38xAFOiBBluKtGsZV5rLfc
         PUckcTOincTSqxaJGunlDjHzskK/VaRa4YqkA5il7JUUhckgkUS6i3jhkWLl7z21hl2P
         V+U6MSNbfUzN9KLb0NJCUfBe/S+yXnvzgNF9QmT0KlDSAZYhTysZUYRlYnHaNBv7lA1d
         iNCEHFIAItWKATN9m5od29Qh/uQtfWIRIa4P3hlP2H9fmwlImrEOqHzuYjYy2MwtcxrD
         urCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KB8xM53MDbr8gpmn3CeTUQXxBIxCyezN/o2K90b2DJw=;
        fh=R1naiegj/7rHepcKG3hoBmqc51iTtKtgnBr2Dtg9wds=;
        b=WNwVseoO6g/Je3IjftHA2+/ME/81x0IGaZpni7j8jd6doC2Ajiise2PKWi+ASRBu8I
         6uwuAjFaLIe9rnA3n8qhQWrwpKbvvUjjGl7JAsnVrSt9sCP9dn0Nln32a+mxVQDYvQY/
         GmApNwjLGPPQLforNLjzlPRwJm7gcTNDOzlmWDOFBePhK1Sj4Omx087BLrRtqnf7To0w
         uP7NicY5Y/v29P0jeIp8SsCbl68qdYJV7v3u73XPGqtoiy336H8e4a7TqJXNxUY96qx5
         ejRR6bmoBTx8azMExqWrRpf6ChVZrS0wflMCy2A4A3YSgMXSGRLBjYH7XILmgMLlC+an
         ukHA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772062962; x=1772667762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KB8xM53MDbr8gpmn3CeTUQXxBIxCyezN/o2K90b2DJw=;
        b=OmnsGVRk5Y+jVGsyvDCFSqwb21OLkHhR5Fw8knxfJJb5jXCM/AD6Oi7cjVNq0z+Tam
         8SKpkrlg3hTXKUwTThmxy2hGBAA/4N8JQLjTGhnCwJcwDyYi/AK9cCyOz2YbNscK2TUq
         S/m2T3AzNOYs5utHEVM2hy70UjW65lTD0gtBCXDYMOW2WJmD9tLwY5eF2RqK/1fAWbu7
         jAT9zqPpj3JDapP4MwlX7mgTQ4Hxh0+8U5SyCIZxxLl+UGb3GU7Y/DZyW1DhEIxJsnQM
         H1tXtf+UoxNWDQnJsfFxSAVUYZbnJuo5nD67YCrxPI43dWR75CYBvxBpxzZSha2iPWAM
         8GFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772062962; x=1772667762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KB8xM53MDbr8gpmn3CeTUQXxBIxCyezN/o2K90b2DJw=;
        b=hkIHrgfEjcaz3vYDbGjezgm9Z4xLLlxRO5KbSxK65QOCnZZVGb1ZhRRVn8D6LELUMx
         tEKGvBzB57hNEMzJjPdY+xuh5GYxFiSL9P2dCjeJo+UJ+p2nj+SLIqWs9iOQ9hVG1ppj
         sCsJnuDsSHkFYa5e2zBbo7BW7xEcZQfjOT32CyZsL8w4WHDSVD3/5gEjV00JKoHr41R0
         3pIYdxTsBJ69H/P89WoCPF3t/ftKWy9AnyiLYylQdrO7Gf6QxYAPqi6fWFttpiJuJEDB
         7HQh1VLGhMB0GFCKaGU7DMfy4/p3vfTo+NcEexDXtctTCYPAuhhxhi+LXuuxKNmghXag
         Mn2w==
X-Forwarded-Encrypted: i=1; AJvYcCX1mlub6DTLuHOrlkvyr1uJywYzbIEvOTPXOGqeGg84lIIV3vJ1eHSp8Jg5/adX/djsKzVXic6eCg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHqUsQQjghX+ZLr5sYklRR4kmbvDfF0nj2Qf5rO8mmCFJmy3c2
	GAg2ai9QoNpdrnEB77GVbjNh5qT6AwBO1L7awQmIfr9smIEV9KzejjdWaKuMPtKyo2ARrFWB8p2
	xEYfVGEFBfIGLEp8k7WFtkdPyGXNU2IE=
X-Gm-Gg: ATEYQzxSblx/RirWQKjht5V9AV8YzrgKJQU2VuerMZ0o5mAIFWqV/GiFnDh/Cw4kgJ3
	jnzm62TQKk9i6WgEuVwvchO0hgHsMoaEd7DrZTOQhCfkVLcIbx/KD9EfCW/qsRjOQb55jkQ1nnB
	kEnOKJor00no3oBRtyogM6BWQvFvFKojBVJH0ea9HA8wSSnwdSJChP4Z5z++o9E2rG9174fSa07
	aGHQI3tNcSxr0mHVrQJK/Z+H1nKMyrbVL8x1cyI8YRamUN7Vgw3F7q5c4tZ9XWIseySt1/hCApB
	U4byhxQc2S42++d6
X-Received: by 2002:ac8:5a10:0:b0:507:3d1:1dd7 with SMTP id
 d75a77b69052e-5070bba1d4bmr253534631cf.6.1772062962195; Wed, 25 Feb 2026
 15:42:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-20-joannelkoong@gmail.com> <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
 <7ccf7574-42d4-4094-9b84-eb223e73188e@bsbernd.com>
In-Reply-To: <7ccf7574-42d4-4094-9b84-eb223e73188e@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 25 Feb 2026 15:42:31 -0800
X-Gm-Features: AaiRm51lxHWaisM9bIzFRh9kWu5jGlrplpi_PsM77Yt4zBmLzvq7gWnKi4bZ9RY
Message-ID: <CAJnrk1b6z2oar_Zw89N275zfyU2+oZJwtozSdTPFw49x38FCOA@mail.gmail.com>
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com, 
	krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com, 
	xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12425-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 782B419EF25
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 9:55=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
> On 1/28/26 22:44, Bernd Schubert wrote:
> > On 1/17/26 00:30, Joanne Koong wrote:
> >> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >> @@ -940,6 +1188,7 @@ static int fuse_uring_commit_fetch(struct io_urin=
g_cmd *cmd, int issue_flags,
> >>      unsigned int qid =3D READ_ONCE(cmd_req->qid);
> >>      struct fuse_pqueue *fpq;
> >>      struct fuse_req *req;
> >> +    bool send;
> >>
> >>      err =3D -ENOTCONN;
> >>      if (!ring)
> >> @@ -990,7 +1239,12 @@ static int fuse_uring_commit_fetch(struct io_uri=
ng_cmd *cmd, int issue_flags,
> >>
> >>      /* without the queue lock, as other locks are taken */
> >>      fuse_uring_prepare_cancel(cmd, issue_flags, ent);
> >> -    fuse_uring_commit(ent, req, issue_flags);
> >> +
> >> +    err =3D fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
> >> +    if (err)
> >> +            fuse_uring_req_end(ent, req, err);
> >> +    else
> >> +            fuse_uring_commit(ent, req, issue_flags);
> >>
> >>      /*
> >>       * Fetching the next request is absolutely required as queued
> >> @@ -998,7 +1252,9 @@ static int fuse_uring_commit_fetch(struct io_urin=
g_cmd *cmd, int issue_flags,
> >>       * and fetching is done in one step vs legacy fuse, which has sep=
arated
> >>       * read (fetch request) and write (commit result).
> >>       */
> >> -    if (fuse_uring_get_next_fuse_req(ent, queue))
> >> +    send =3D fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
> >> +    fuse_uring_headers_cleanup(ent, issue_flags);
> >> +    if (send)
> >>              fuse_uring_send(ent, cmd, 0, issue_flags);
> >>      return 0;
>
>
> Hello Joanne,
>
> couldn't it call fuse_uring_headers_cleanup() before the
> fuse_uring_get_next_fuse_req()? I find it a bit confusing that it firsts
> gets the next request and then cleans up the buffer from the previous
> request.

Hi Bernd,

Thanks for taking a look.

The fuse_uring_headers_cleanup() call has to happen after the
fuse_uring_get_next_fuse_req() call because
fuse_uring_get_next_fuse_req() copies payload to the header, so we
can't yet relinquish the refcount on the headers buffer / clean it up
yet. I can add a comment about this to make this more clear.

>
> As I understand it, the the patch basically adds the feature of 0-byte
> payloads. Maybe worth mentioning in the commit message?

Hmm I'm not really sure I am seeing where the 0-byte payload gets
added. On the server side, they don't receive payloads that are
0-bytes. If there is no next fuse request to send, then nothing gets
sent. But maybe I'm not interpreting your comment about 0-byte
payloads correctly?

> I also wonder if it would be worth to document as code comment that
> fuse_uring_ent_assign_req / fuse_uring_next_req_update_buffer are
> allowed to fail for a buffer upgrade (i.e. 0 to max-payload). At least

Good idea, I'll add a comment about this.

> the current comment of  "Fetching the next request is absolutely
> required" is actually not entirely true anymore.
>

I don't think this patch introduces new behavior on this front.
fuse_uring_get_next_fuse_req() is still called to fetch the next
request AFAICS.

Thanks,
Joanne
>
> Thanks,
> Bernd

