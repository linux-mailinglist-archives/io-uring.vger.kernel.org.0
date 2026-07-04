Return-Path: <io-uring+bounces-13883-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5OcPJzphSWqw0wAAu9opvQ
	(envelope-from <io-uring+bounces-13883-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 04 Jul 2026 21:38:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D1D70842E
	for <lists+io-uring@lfdr.de>; Sat, 04 Jul 2026 21:38:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kHjxfbQb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13883-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13883-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D51C30221F1
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2026 19:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474252D9EED;
	Sat,  4 Jul 2026 19:38:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66FB196C7C
	for <io-uring@vger.kernel.org>; Sat,  4 Jul 2026 19:38:29 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783193911; cv=pass; b=DSbtLuUxy9mKJ4kPLq9iI2EA0LdRx6SnNMVcuATMZoqSyXGKUnQXMx3EqoJB0OuS0QyDivJ/WM5cbl8JsEuv8PxQ2tPYzFSr8WqV5zVwfMnbdvgUm4SpB/NNlhGHOVxH5NZ7CfCfuVzC1bjzNrEZ5D/1zBjsYzPQVZA9w/Mfccs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783193911; c=relaxed/simple;
	bh=SEtBJTKjRTIAqMkJzN4QIVfzKlia/YUS2k99Z1Z/Ofs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MmTLopFgYju7PNZgyXDnRZ2//TUOQSic/dccEVOejA/NrULJWnSnKAWQ9v8BxsWyPGaHx5yo4jbsskZwyTJecWa5l0jC2ix2eiU9oWiXvIBmUo7qzAVo3cb6joF7Q/dektIbs/smCSCepECXvQF+AiXREhOmpVjcQT/WRqZFsKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHjxfbQb; arc=pass smtp.client-ip=209.85.167.49
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aebf9a509eso1640337e87.3
        for <io-uring@vger.kernel.org>; Sat, 04 Jul 2026 12:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783193908; cv=none;
        d=google.com; s=arc-20260327;
        b=PGK9z9epZiyCAqh+7CqGLv6Kfb1hNkerXsfdCJw30OPu1ARk5oOT4UowDv1L2wzoZG
         mtONBQJkjivMF7rlUPjI85LFnUzfEkefBOaY23Kbw+m9Cd1fIVLmj2+69OFo2iPYAJgb
         KXseNgJWM7L+zQ0HiltmeLDY49Rwm8UytydRswj31Bj6rlX1xiUOJuE6CjbC1s9YubQc
         A1Fkvolxn+M900AilbyJMwwszSHiA3+wW7Nl2TTOYgqQW0+5b1vnVnQa88qKG8+RbGYZ
         +lm2fCmfvRteLdCK6ifoJHBSHn9/yq5gPp3SJElAgOX6/c85Mq+Z6TrYJAP4e8fQISDp
         MxjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8raXoFx9sKY+qt5CTWwoeRXFF7p97/7IBuvs3xv/fyw=;
        fh=pMSBQ2vjWIcnxxyUcuM3TiA9TcGHl8QdYd9ydD3iM3w=;
        b=g2V1CjiiBipt/xdQ93sWTbFwg9wCI7DTwCAsOGmYnvM+V0kNowcT9O+1gC1yc6kqca
         o/R+LvcrbhrA4yaGYFhml8Y/soma50UhYlRdtOkxow5q4Roib4CV+QlGVPrD+4pb+Nw9
         cSsY2zxtuKLyyDqH/ZfaU17zpqOilVjDjzH6iRlHO4pHFcGMUuiQHgaAamcZv+8Qelhu
         cRHFJBPMPTSGHjdBOeTmuNpRInUo6J1hryBiG0JkiNXBEtIaTKWFuGW3pM9FhSg9S1pM
         mtaWzAurN1UwavZRVoUnZvgxtJWJInvMVxOwbyi8UBA5wA/XCM5n9YyJZffX+Fs0Mybo
         Xnew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783193908; x=1783798708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8raXoFx9sKY+qt5CTWwoeRXFF7p97/7IBuvs3xv/fyw=;
        b=kHjxfbQbNp1UOiHrIoxW+Axr19Q6w7xCuRLx+rlJL4Ozoqog1S1lqLFsUL+ekIe821
         tCfaoorLbJY3na1TEwbcLi5dQyTgmk5jXGlWrFTDrLhKcgxI6u45cxYBt9doENACsJdN
         lyiDSBUYJEv8PW/oMOA+AErwUMk6iVvlQPx0dA+mt7xA7x/+JgjL6iiakN3AZfO8Bpr7
         DWb97w08Z3g+XlXb8GUAzUJSs8Ni7KVJASufACCn2bZAmnmILxzW7C5d5635Y9s4cPWG
         +2iBUHfMWI69sd54lnOmUL3jCZ6Y5P8ViStPd68fC0j4nvIpQwDgiaIvxfrhP4WtEhAp
         ceGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783193908; x=1783798708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8raXoFx9sKY+qt5CTWwoeRXFF7p97/7IBuvs3xv/fyw=;
        b=L0yB1/BeWyAohuQp5ErpgFgXwcOxdJlwVw1HozaDK9wNFppCtiGKU6ZZY7IlHAL3FH
         i7x9nZJWiFasmYydUCTvn5Pr+mcx2X0UP6i5XwfB1QiGTfyr1JOnHPzGS8LgS0Q520/f
         YGcOOdNLtTlZn+dSMfcHnq6zbG/4HKPi37f+F60zA7XVUPRoZi38V8v8hK6lbPHRAsbT
         EERIu8H418IuggNRWA89fIhyyR/p6serhvLgag/AATbs0QJruEm0Ky462NGhWaDZ+/I3
         GyeEoBBei9/GeV2LusYyT+Kr1tWCmFJwI8YlD9FXRjvt2xT9bZDdf7F4ROmT/A3NEJPF
         lMoQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq6m5fcOacbyKNafp6R+owLMJb/DHCbBZVOMRPMhi/kRlo8nX8jFvfvczbAhQHm/xYhrcE/Bbv1rA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxV9nqCqOEmRrevBVL3axuHnHW1Am95L6bYzb1WP1Z1g3QSEpNa
	+Zz8YEsFxAm/j6vqpm53YEecVr6fRnSyZNxajC5DaWvStyT8VOg4ubu7ksnGUKCu7XKcECp1EXk
	5N7sJFaK4RkLDQ0q0e5Yb9Br71rg8AFk=
X-Gm-Gg: AfdE7cmXjoAnE2E+JjabCSEh4tblUcg7X1xmOB7+zfJVfl2QQx/bYUlsGvQ/DPDfnu4
	ymp7BufsISF8gYVRQ5INybEEa25g2UtU75hXq4AHKwVMrpQAMDe7TS9iXXBvUzNGXQqk9NYbTEM
	3X6DDt/BheZ6Khqj1KC1B75we31W4yA6LGJGwZsRVwWYJmsCn9EmkU6cc4V/z/8Lm+iR4e92LEO
	06brO7XPws0DYRCymrgPk5vXsdFs2ziFcHScV8AG4dTX443c+EPLwJIXcE5DVDkEBVA7VPO+aa+
	Mt5NSm6EU2zE3AB7FkJHuQ63D7m/EDRnZv8aEWIDWWQmBxKSYEXizUXA
X-Received: by 2002:a05:6512:3f21:b0:5a8:88f8:9ed4 with SMTP id
 2adb3069b0e04-5aed50af36fmr748644e87.30.1783193907980; Sat, 04 Jul 2026
 12:38:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk> <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk> <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk> <aj6tTiAB2NIol9Tf@kbusch-mbp>
 <CA+KFGSoyCSRzgamm-38oyAtEsqd7wZZ8awL79P40x7a819EK4w@mail.gmail.com>
 <CA+KFGSoZXejMvA5WNBSy=TVxiEiJs1-bxHXkewk8HtCR5m8sEw@mail.gmail.com>
 <akk8Xhyntk9_weMp@kbusch-mbp> <CA+KFGSoGVBzsnhht5Opo2PCf33M0uiLjK7BNQ-t2DjTDudwXrw@mail.gmail.com>
In-Reply-To: <CA+KFGSoGVBzsnhht5Opo2PCf33M0uiLjK7BNQ-t2DjTDudwXrw@mail.gmail.com>
From: Ben Carey <benjamin.james.carey3@gmail.com>
Date: Sat, 4 Jul 2026 15:38:15 -0400
X-Gm-Features: AVVi8CdcIZqN5VSgXn01EUozrYq4sycICQpLvv_qRjmWnANtSKR_0qUB1LvLYkc
Message-ID: <CA+KFGSqS_Cr4tgs=wZuh7xzXwfpxevt8Re_K8Ej5b0S3j+_QkQ@mail.gmail.com>
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:kbusch@kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13883-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D9D1D70842E

On Sat, Jul 4, 2026 at 3:35=E2=80=AFPM Ben Carey
<benjamin.james.carey3@gmail.com> wrote:
> We've seen, however, that the timeout can occur a large number of times e=
ven
> with high queue saturation. When running the fio job below we observed th=
e
> timeout 132757 times, which I'm concerned could negatively impact bandwid=
th.
>
> fio --bs=3D128K --direct=3D1 --iodepth=3D256 --runtime=3D200 --rw=3Drandr=
ead \
>     --time_based \
>   --ioengine=3Dio_uring --hipri=3D1 --fixedbufs=3D0 --registerfiles=3D0 \
>     --sqthread_poll=3D0 \
>   --numjobs=3D32 --name=3Djob0 --output-format=3Djson --clocksource=3Dclo=
ck_gettime \
>   --filename=3D/dev/nvme0n1

I should note this was while running in a VM issuing IO to a virtual NVMe
device.

