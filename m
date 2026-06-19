Return-Path: <io-uring+bounces-13788-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id iOWPGITyNGppkwYAu9opvQ
	(envelope-from <io-uring+bounces-13788-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:40:52 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6543A6A465D
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:40:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qHElcIwv;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13788-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13788-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 53717301861E
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 07:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED52C3546FD;
	Fri, 19 Jun 2026 07:40:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2C335BDB
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 07:40:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854826; cv=none; b=rjOnpVFezK9LHF6im9cOGg94NiWsZ7dtXg7vtfanRjslX7T796QtgFRtUd9jMnQUGY1KBV8sbSny4F7EqvRCv/3fZ5MAvSug1cx6XciW/Dn4sh9nkMBAgtrNQriTIhOuIat5jkbFhnLwvBd1N0jeSi/176N7st/uJmCKljn0p9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854826; c=relaxed/simple;
	bh=2Qsm7oOOrR36fFL8O1zr2PwgV7uJ+NhGTXCp/hPxneg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3v/UwWGCNi3GlxzWGf9J4JAAU74aWNCE2mpLVF8d/2ujbQtoTC5UQZzOknziHUJdZEvWzkW4hYepVfc1uy25gaGODtSue6Qt/obO7+3NqchDshTD3rtiDVDCauArMnDYbuNjv2Dfb/XbJy7BenyGOTYjxUtZw93hU44kyaGqb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qHElcIwv; arc=none smtp.client-ip=209.85.216.52
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36b8e1760ccso962169a91.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 00:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781854825; x=1782459625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8IoIRgPFus0dtAjx1VIV2D6Zb5vLDM4e0T5cbfAtys=;
        b=qHElcIwvelE2WF0B6fksaKuU3/ZKXYAsyjV2jpxUl/YAsx+TCMrLkmvpkzGEAHEq6B
         fiQb3mtrdaksHagik3VdrLG5etilCWX3To8n0KE2jwLHdJnNpbVLywB1VRAR5HUhn/IC
         OapyedOvwfYWc3H9/qezkuBWmXeeKoaq4L7/a/+WSD4kOhtwGo7TWTXIZPl4WFEKUMaG
         oBCsY6ZMtEPVQQtEGocqHUGghbhAxnsrh2UwNwxIXyZuBH8VskurEz9yZkkGmudSglLC
         UKvyKJIlRkmGSMuBGe706fSn0q2LjfNZsJl/cTbzkSQq1WXCUmjeA4O/df5NqvbEyvC9
         3c9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854825; x=1782459625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u8IoIRgPFus0dtAjx1VIV2D6Zb5vLDM4e0T5cbfAtys=;
        b=RqapLLnj/PUJb/XUKKU/UIe2xvsxg2rPy+Q9tCjESkkLSw+Hn9uFCxo+UgliBNv91F
         jnd3SHLol/fHetrWYjQeC4BRi/nJaVwivoMssnnfVyz7xuA6e+rs2waZJ0lrAuTAUVEN
         A9wOfjOTlCcBx1rJaSNpZboy4QEWyUAslPp8iqWFdPXau8ABW/M1e9IX95Qufg13x2bd
         G8qzoVhAS0QmG/OFwvd7DnMFW2yapBhqxU/1GmC7JfJtK0YCngp9I637mcyGNPQ4pq/A
         B1CJJ9lIzwAuF0TFd2khkz9X+pN2rCWXJWvPK1JqbGrBBui8eirjHXFwoELbEPp8DVDc
         UdXA==
X-Forwarded-Encrypted: i=1; AFNElJ8jXJIOyoWw7G1UNBJQv26JawblWnd5t0oiCcpG1is656F+bKmRmd7FOwe7nPZabXHiQSdvEPp2pg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBQnKEqQDisSDv5neSs/xlLehfzOuu33Ec8wm8YeX6nWSo2VtI
	xwrxpk568kGAXEvi3jwCp5idjkUHi13vWcGGk6NMvs5TXAtfN29Ru8Km
X-Gm-Gg: AfdE7ckc6eD0ltoze867ulkj/lfkh3mc6VYL3dHjyZxGHTDjDmk1x3f3588d5adrrTy
	rb7czMy0M6/Ic2l1qKzREsA2fthuzAlwcE4OVUqmctZQcQljeciuK1mgelnw0V+iy8dAY+1Q8+1
	JOAlT7tjHD5Xw5ijGKgzjYKmjzpG3uC2t5KOP0JczDM/0wbhxC6SKoqSErPSaCXEcCS7H4CPl44
	dF6bnykyfBNI/kAWQinudq++2boIArzVsDb5rwA7RyZR7s+/QEP2oJZOT+IW/ywhkmGbHKoTGQ6
	abIIkxNrdUomVoz5X476/++ck6yhTrZkiFhWGXuC/bmlHIYyi1V0tTHFL4MXc/vxL0hpYe6RTb/
	5QhEocrUu+/kOGuiVEfkXIAMDE3xMwnIwjTdBUVn48X/p+cGOQUynN/D0eT5RA72AJ8xDZtfIiQ
	1oOgPC+gPAoxLEYJzBaGC+g2HbTfqN3L2PJy0Gdr7LBBy+rw==
X-Received: by 2002:a17:902:f54e:b0:2bf:7b62:a038 with SMTP id d9443c01a7336-2c718ca5fcbmr31211805ad.9.1781854824925;
        Fri, 19 Jun 2026 00:40:24 -0700 (PDT)
Received: from Athena ([58.146.97.175])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c720c0ec80sm14754875ad.76.2026.06.19.00.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 00:40:24 -0700 (PDT)
From: harshal24-chavan <harshal24.chavan@gmail.com>
To: krisman@kernel.org
Cc: axboe@kernel.dk,
	gustavoars@kernel.org,
	harshal24.chavan@gmail.com,
	io-uring@vger.kernel.org,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Fri, 19 Jun 2026 13:10:11 +0530
Message-ID: <20260619074011.15289-1-harshal24.chavan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <87a4ssyey0.fsf@mailhost.krisman.be>
References: <87a4ssyey0.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13788-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:krisman@kernel.org,m:axboe@kernel.dk,m:gustavoars@kernel.org,m:harshal24.chavan@gmail.com,m:io-uring@vger.kernel.org,m:kees@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6543A6A465D

On 6/17/26 18:33, Gabriel Krisman Bertazi wrote:
> IIUC, the IORING_REGISTER_DST_REPLACE exists for backward compatibility,
> since originally the buffer cloning would fail if existing elements were
> already there.  It is kind of superflous in a new operation but I suppose
> it is here to mirror the semantics of io_clone_buffers, which is ok, but
> then...
>
> This free should at least be gated on ctx->file_table->data.nr.  We are
> always replacing the ->file_table if it was initialized, so it is a bit
> more logical to check the table directly.

Agreed. In v3, I have gated the io_free_file_tables() call directly on 
ctx->file_table.data.nr as suggested.

> > +	/* not allowed unless REPLACE is set */
> > +	if (!(clone_arg.flags & IORING_REGISTER_DST_REPLACE) &&
> > +	    ctx->file_table.data.nr)
> > +		return -EBUSY;
> This check is duplicated in io_clone_files.

I have removed this duplicate check from the parent function in v3.

> > +	src_ctx = file->private_data;
> > +	if (src_ctx != ctx) {
> Shouldn't we just fail if ctx == src_ctx ?

Yes, I have updated this to explicitly fail with -EINVAL 
if ctx == src_ctx to prevent self-cloning in v3. Thanks for catching this.

> > +		/* Prevent cross-process hijacking */
> > +		if (src_ctx->submitter_task &&
> > +		    src_ctx->submitter_task != current) {
> > +			ret = -EEXIST;
> > +			goto out;
> Is limiting the feature to the submitter_task necessary to safely copy
> the table even if the lock is held?  The use-case for this feature would
> be setting up a single ring with its file table and then replicating it
> on other threads, on the common model of one-ring per thread. This check
> limits it.

I have entirely removed the submitter_task check in v3.

