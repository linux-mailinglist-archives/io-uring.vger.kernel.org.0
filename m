Return-Path: <io-uring+bounces-11840-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OAM8M0qob2kaEwAAu9opvQ
	(envelope-from <io-uring+bounces-11840-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:07:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5A447190
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 568865ECE35
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 15:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52520438FE6;
	Tue, 20 Jan 2026 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e87tDeYq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA08044D031
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768922694; cv=pass; b=KDy5q8AlxjYJOtUYgvBKsUzb84uCRjUf0Aw4GKisQ8Z3m/BwbGYsRmQhI4ffvpnvextjKiQGpXK7DeVPT8LGvLYaDdXR4MNwyA9B9aAgfaSRpfGqNUgdMesJwDWw1NyHkfyAZKKVltGWAhADpbUIkrf4dUxnzq22fOu7tw+weBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768922694; c=relaxed/simple;
	bh=1qB6CMN93+ojpM43f4NIoXDe9pey8F507jEwLmIYwyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hB5L4gBltK7jiA/EDQVJGZGJF+Bz7yL89L9ep8wElbqV/9Vvz1cHbzQLUHgloN9eU4dgRXcxLZlOozZt/WfWcVfR43yWEQxl4YA1HUe+aOIr5y6ToCi1TH55TZV0GYFuLxQ2cYIZlQvj6IDQG+KAd/ewvxVBOjJynWOSnMyJMBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e87tDeYq; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40438a46d7cso3257058fac.2
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 07:24:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768922691; cv=none;
        d=google.com; s=arc-20240605;
        b=Qe5qXU5NZjs0zHdYFhmoSAFG/QtFTPvj0yk6kic18LwjndQpvj5aXrH685H4mhZcik
         iZ3rAZQ8u3yHrM0YY+kkdDd3Q07uq9CVdvUMJfUCaaSozGOXeAH9ePJvn61ln/BsUEXa
         djs7zc8hMLVeXeQ+nV8mddlLNFR52s/NRHHs8a0swGhMMYLzbjyhBtbsvsmMasUth3c1
         0kcAOmE39aJf7KXPOyZTZFH3sxwIKOvXZIgS3o8zb3G9WAKJ47MnhdEQ/LjDRQp8sTEW
         mipJb+V5V49tvux0vvBwmc9cfGdeDtE4V3p53zUDzqcBEWTju2ZcJXoR+ce3x06e1Kwr
         RLSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1qB6CMN93+ojpM43f4NIoXDe9pey8F507jEwLmIYwyc=;
        fh=V7xxu4TShTKuEcHU6ve9p9e5OrXMXOBpwlBi2FHzjEk=;
        b=DwcpLbqbRnMGm3/2vfWZIPooa/rhi20h80S1lpd4jlcvSq1kD7v8/+rLvBe+Nnh+U/
         Rb/XqVMwvC26harM53MnVbBhHcnZ66W9OaJrf50wpqy471a705QLWRbERMX8KXJabL7S
         iPpygxmiG3VsVzZpd0hbrO+Yqi36ToGFTfCvcaJuREh4YwK9dR5ql4/WR3d/4inxvv02
         BQx4v3FtUw5f3LDHKeA4CpY0HZFutA1oeOo0Uen9ky2hG5vf+7Fg9w7KaccqC77rB5cn
         aJmaKcCZJAehQbOjQ+a31iMwtxUtARc6BGJ0fnHoSPUlM6U4jPhL/4N/2nsClua3Z1sO
         3QhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768922691; x=1769527491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qB6CMN93+ojpM43f4NIoXDe9pey8F507jEwLmIYwyc=;
        b=e87tDeYqg3lSaBRqonixacxaGdy7m+r9FpEq2FENhbj0EUbf95Sc2bq5TNw7q+IAb2
         fPR+BXgghnqgcu9M6Rmj3JKTMVu1zhYkSwtqE4rDYxf/O7tvDmeK0DBFiEb2idV9CApK
         u2CnpJ7LQOIbPrSAzePUhRd1woSBfbED2OY5NRWgEQti4X8BdK7e0GEsRJcqKxZS7tBK
         ZDz/sBoKLYpfpjDyf+ig5yjnUoO8CWGRLbcFhdtOI1/o5Yqkg+elygRv+kjnensIF36J
         Qjz0Hl5bGzIOtuOIzcBYSuEmFxWNLsFPiF/dJa2Pr5jvU85c8kcaX+0BZkjXQEoMgItV
         w/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768922691; x=1769527491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1qB6CMN93+ojpM43f4NIoXDe9pey8F507jEwLmIYwyc=;
        b=R3ktNCxdyoYsjRRcPxiFTPtgP7UcnOaJgjo/0fwue/GfNxYQkRMNZu/ouwAF9TEqp5
         v0HnVuMkkYEZOmLDeMch8/3HXLVJaJn1gGW0Te+aPjgv8SQe02VLDB09J2b4/W9yDLhv
         J9MLnAMia+BhZpuJS0ttnnKl8WGFZCCWcs3/6Hw+h51oXKvreS37dEoTC0aLgLaxs4Gj
         ZjgFnlf3+lhBFo6z4BVzg2JTb/q//CcAuY3HArpwiWa7rO3VQms57MJQsTryrcGMwhBG
         VyA8FkPuZYIaYFmmi7Ke1B4JIEBzvloZyaP8618DMbQctznEpp1beTIuLg3KTIYYitYI
         yr4w==
X-Forwarded-Encrypted: i=1; AJvYcCWWik6I9NVRlffceGTTEkpZKEyvcrjaz+zrk4c9p335fNnoTP3R4jxurMB0SfAC5gHm5gPGnHqHCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy0GZ97vLP3AexAbGMrAv1FkjcxRdP6lIMSvZzkc6p2yu10ph3
	pNZ/5zgq8S5z7A8PaQ7eNVrWWAfmjjVkR+4U41z1Q5aa8XMpP3l3qS8FJRh7dILLDNORvWS8If7
	Gis6B/fq9t2yQXhhYOd4YtXaCEK4IoQSdJd6qQb6v
X-Gm-Gg: AZuq6aIvOTvAvEBxsIt/2XGUMbiMQjMNW4eBVXtnzfbOKZOwk7qC4l+pd1VW4K8s/YJ
	GkLaPpY3ULZkPP5CSfXSNugRIYLZU2iom8xjBeQNavg2GEgIHTHMC4z7O/7b+E580oImApcNTYq
	LZq+HMeXFsXCgQOvCUUrlCga/VTUcuMnEpxykfvt18p80p5AlhFYvuNSsKo1DmrRW8UR4uEQ875
	upEh4Ka9zd78F/5D/ycGThDcFVVJ+AX62OFp9FOdC+FU5m/Xbl5lJJkhbJ2XIr6+/BUhib+Mvj7
	WDdEzoAncy4VZyE9kobrYSLVRKCx0NP+l56bo0GYd160jdP+HsEOXLETdA==
X-Received: by 2002:a05:6870:71c9:b0:404:3a5b:58d6 with SMTP id
 586e51a60fabf-4044d02b3ebmr7052079fac.48.1768922691041; Tue, 20 Jan 2026
 07:24:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <696d2952.050a0220.3390f1.0022.GAE@google.com> <e54bb96f-9e18-4598-97a2-c835d9424a9d@kernel.dk>
In-Reply-To: <e54bb96f-9e18-4598-97a2-c835d9424a9d@kernel.dk>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 20 Jan 2026 16:24:39 +0100
X-Gm-Features: AZwV_QhdwgAwfyTckXQPILeLfbkD0Qr-pCw0uD16mzK0RYqkb-CNz3Xnjx-qxug
Message-ID: <CANp29Y5PZ44+QL5e-aw4O=TQV3xxvG_NESE3bZ0iLw+JbGJjgw@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (5)
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+321914d39d7553cca1e7@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, Pimyn Girgis <pimyn@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11840-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	DKIM_TRACE(0.00)[google.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel.dk:email];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nogikh@google.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[io-uring,321914d39d7553cca1e7];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 3C5A447190
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Cc Pimyn Girgis re. memory leak detection on syzbot.

On Sun, Jan 18, 2026 at 7:44=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> To the syzbot people:
>
> https://lore.kernel.org/io-uring/9e600e62-499c-4f4f-a4fc-846bb0afb110@ker=
nel.dk/
>
> can we please ensure this is done before posting more of these? At least =
on
> my end, these aren't reliable at all.
>
> #syz invalid
>
> --
> Jens Axboe
>

