Return-Path: <io-uring+bounces-6600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C370AA3F897
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C709422022
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2755215066;
	Fri, 21 Feb 2025 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="A3x1vDI6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vCsn4CRw"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78032215046;
	Fri, 21 Feb 2025 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740151507; cv=none; b=gmaiwUT4x7ZOL7jdHs5QYGpN3nl+96trgMuT/eb2AUPpFVe1pig/DRMk16RhKPTCCkzaUa2a+5eJ6YBLQXTFNMfT85Qdft1rUd9XGSNYYPqbytWKA9lzRPQSCXmqLZ9S5AAYHQN4oqnfXSo3NB+TXZOMroh3kzBFdbyDRF6bZ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740151507; c=relaxed/simple;
	bh=teyDPYa0fnRXiWggkeEtuU9eq2yF06fwn8kZVPQChMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DWNpdtIideqIu5/c8AupHQ+EMzajkHA0Hy9SFxgcyQkTZX/crq0QnYYLP13z8Y4PmvHJ917y6xdeZxK1tc7PPGtBPlRKkbVhuNxHDTD06jtbj5oyMF2mJuF5o2YcthWIG1PPWXuF1Jc3/LGm6dWWeL+aRPK5a+vTIE9bY3OIlZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=A3x1vDI6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vCsn4CRw; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4CF5E11400D2;
	Fri, 21 Feb 2025 10:25:02 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 21 Feb 2025 10:25:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740151502;
	 x=1740237902; bh=ZZvhYFWk8cEkhOwTiqI1Zgpddj5j0vlitWdCpGP/ttU=; b=
	A3x1vDI6U3aGOZ+QMhnJVfDqs5VnidbjQSqJfmDinuc4fgEQdgW4IfdObHo2+AQH
	o/MvIpXSeCXYBMj+HWtPp/E70gcBJw/FvXRHczmI4Qak1VGl/smja7nKXxQDp5r/
	a/fWFew2UsPXhv2JL0WZDNzvmCu+yVnaVnPZGf6fjGnyEhIigkuxGwgPm6kNm57u
	FpVSU+C3nTsDq/ZqWFSgnxscXPVo4ukxwQRPLPt03xLATSd6HpM/Js+WBhYk7Ukn
	Ta+e+EwtRgtU7ZHk8S2DJ340QuAN5vTWMob0m/jXmo/xPm8eRJXIvgRDShWkWA2D
	toX4/3IoKvJv/IeW/hY6FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1740151502; x=1740237902; bh=Z
	ZvhYFWk8cEkhOwTiqI1Zgpddj5j0vlitWdCpGP/ttU=; b=vCsn4CRw+pcIFXDxG
	d+IokbzXr8p3Scl5OuPSKeaHiLJaFJwa4V+4XToE1q+KtZl1n00Bhiq8NWUgwJcG
	soCZc9tTD2qrs7FKSwNh3oCkcDdqSQ9kAWlHtK7PLUBNT8yJ7RCe50HRhRWykOmu
	olEA14+SZ1r1ns3KMGSZ5FCEu880b/idiIwJm8C/OFwjb1OdCSgrbE2+U+cJp7FI
	U7qwd3WhDv3Rq2czr5hovZkB9HzmRsJwsxCLlCdpNasmh33xWP1g+YfS70s2X+vL
	0TaMITdyFiXo5o649dvO+Xph711N921gwdOM1PMkSaLhUg3XmNGrPxhMxFknuc7J
	0SDNQ==
X-ME-Sender: <xms:zZq4Z0CrgJ3vC_XWMhHIh1q2Eq21OHyuG-eTlgqMgzGS93ftmnapuQ>
    <xme:zZq4Z2iGmlDgxu1lIZ6duqPpFDIjlm-nIOn0hIacU9Q7he0drgwsBd6UA6L3TDMHb
    KTrehWkkC85jpyv>
X-ME-Received: <xmr:zZq4Z3kCzTWlOJEkeZsZGBF6qQrxzXom2Q1WqvTEkUEWprsWLwcIIMhxzKmRWEsD48tZC-qJaojReyPkvoiuE36lDWvaRa-gJhNZrtyTwjOyPaOHaQYO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpedvleelhfeugfehudfgfeetueffjefgtefh
    ueelgeeutefhgeffgeeuffetheegteenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmohhinhgrkhgstd
    dtudesghhmrghilhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdr
    hhhupdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:zZq4Z6wv8pIlQ4l2FPBtlatu0TvFAIdLpZyJ4YDQieya2v_UUL0qxQ>
    <xmx:zZq4Z5SYxn6_5-2UgcMws2Q48XqRMgHaX-ePBDcmqB7uHYpbKX5Zrw>
    <xmx:zZq4Z1aL-uhm0IuiP7mvUL03gZwJiOWftz5oVKxrPplQPLhgmADgeA>
    <xmx:zZq4ZyQpwsXfnrD-hZTqGnF_IAti6W_-WB260Iq8yB_WKzAE1nh2vw>
    <xmx:zpq4Z4Fgb0NpWFpOb4wRRK7X37e_7FhxFOUYh9LStDZddNZTaOsjnA5v>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 10:25:00 -0500 (EST)
Message-ID: <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
Date: Fri, 21 Feb 2025 16:24:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Moinak Bhattacharyya <moinakb001@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/21/25 16:19, Moinak Bhattacharyya wrote:
> Add support for opening and closing backing files in the
> fuse_uring_cmd callback. Store backing_map (for open) and backing_id
> (for close) in the uring_cmd data.
> ---
>  fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fuse.h |  6 +++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index ebd2931b4f2a..df73d9d7e686 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>   return ent;
>  }
> 
> +/*
> + * Register new backing file for passthrough, getting backing map
> from URING_CMD data
> + */
> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
> + unsigned int issue_flags, struct fuse_conn *fc)
> +{
> + const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
> + int ret = fuse_backing_open(fc, map);
> +
> + if (ret < 0) {
> + return ret;
> + }
> +
> + io_uring_cmd_done(cmd, ret, 0, issue_flags);
> + return 0;
> +}
> +
> +/*
> + * Remove file from passthrough tracking, getting backing_id from
> URING_CMD data
> + */
> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
> + unsigned int issue_flags, struct fuse_conn *fc)
> +{
> + const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
> + int ret = fuse_backing_close(fc, *backing_id);
> +
> + if (ret < 0) {
> + return ret;
> + }
> +
> + io_uring_cmd_done(cmd, ret, 0, issue_flags);
> + return 0;
> +}
> +
>  /*
>   * Register header and payload buffer with the kernel and puts the
>   * entry as "ready to get fuse requests" on the queue
> @@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
> unsigned int issue_flags)
>   return err;
>   }
>   break;
> + case FUSE_IO_URING_CMD_BACKING_OPEN:
> + err = fuse_uring_backing_open(cmd, issue_flags, fc);
> + if (err) {
> + pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=%d\n",
> +     err);
> + return err;
> + }
> + break;
> + case FUSE_IO_URING_CMD_BACKING_CLOSE:
> + err = fuse_uring_backing_close(cmd, issue_flags, fc);
> + if (err) {
> + pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=%d\n",
> +     err);
> + return err;
> + }
> + break;
>   default:
>   return -EINVAL;
>   }
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5e0eb41d967e..634265da1328 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {
> 
>   /* commit fuse request result and fetch next request */
>   FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
> +
> + /* add new backing file for passthrough */
> + FUSE_IO_URING_CMD_BACKING_OPEN = 3,
> +
> + /* remove passthrough file by backing_id */
> + FUSE_IO_URING_CMD_BACKING_CLOSE = 4,
>  };
> 
>  /**
> --
> 2.39.5 (Apple Git-154)
> 

This is hard to read - all formatting got lost? Other than that looks
reasonable.


Thanks,
Bernd


