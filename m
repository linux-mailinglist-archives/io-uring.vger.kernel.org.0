Return-Path: <io-uring+bounces-6604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFCEA3FB00
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 755B919E3B47
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0B81EEA33;
	Fri, 21 Feb 2025 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="qfYKGQbL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="zt3q76WR"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E506D1EE00F;
	Fri, 21 Feb 2025 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740154463; cv=none; b=So5tZp9Ib4j1kZO9issSmxmzWQIXReCI2JSCucT7AV31a6y9aAkbDzwbgqtPhZwxrCzPYU8tu2L2Dyu9lKPwNLByYmICodAcBW+qI34ODuGzjM+Bn1CrCAts283Rmh2vL8/QETIHrbafGXLAewnuT669hVJ/rmMhCFGp8E+BIT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740154463; c=relaxed/simple;
	bh=ExfyjFqkKI0iCNjaghRASOzNdKzkRxb04wUYq0WAAVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KavE1xcwUKUTNRZzKxm2gb12qb93tqiSWxWWGR4I/o1ZqrjhBIdfkjcR8Cp4eKpnQCI8NCPpp6PvKeQwlZTOuvzaDU0K1TgRXZ2TrX02PNAjEyTumb3+lIV0hCWllrg+y/7dvtx9kVt2QaC3XPQimefMRdEv7NqjnccpcmkEv8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=qfYKGQbL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=zt3q76WR; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id EEE1111400FE;
	Fri, 21 Feb 2025 11:14:19 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 21 Feb 2025 11:14:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1740154459;
	 x=1740240859; bh=8OHWiU5idwpL5IoFlDcAWyDfv4A+id7994s56hsNyac=; b=
	qfYKGQbLBalNAwkwJu1VjCOAO14/jKmlk4GQhyYOoEvzlReCt8Zmlvj5r8mko6Qe
	FZSDJ/VxUhnx3eZN9obz8shmjO5lHq6+TIXQd8pHXmmBZ849hK9FdNqihQnyM+Ox
	GfPPCESj7TYEbYNYqRzRTUCVflqOW4rBGujYPu7lfnVVyu3XwhD//ew5C/VTeNSO
	I3Hd6e+o/mE9qBRrQHKxE6q0WONIWo9gx74kdBAiCWt4EqImTkhoU50uFFNuyz/a
	jW5TcxrJBsFM2+Wu44Ht33+PgSTjOcJuOGs7nVnV7KooP76KBut/Z3v8eNNGjerm
	Lw2zdJOdvfbJQLCNSJHPiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1740154459; x=1740240859; bh=8
	OHWiU5idwpL5IoFlDcAWyDfv4A+id7994s56hsNyac=; b=zt3q76WRAOY8JdP0C
	27fFFqMUNXYLkuHIpfppNmEF9F6UHUwFp75YG/QMOwRz4OIAEw3sQYQyA4jEyFk5
	iweLvFyhrL6JEf3OWNhmd7x0I4txxflwSfuX7fZkcG4kJlTqFebWjb6Zy3ga5u4W
	tLdGqY1CcXfiJZ/nZ+bWe6W3V9rsLCm6ITOXM5z4JBJIeA7gQnYajEPZKCBmM04C
	cxiC+JBdMr/yExugCYOFYpLopB4pPMsA2E0qQD7SkhJzcOojzSt8knM48d1l8a5I
	T4p5R9tk689d8RvdpMc9y4wP8xUyCkDUxRTEXghAaLDtJyBJZKDgwOPY2148JLPt
	jpSKA==
X-ME-Sender: <xms:W6a4Z7VEynJIOd9uc1dYagoolpxJ5GqqtBAfJ3i7hYI2qHwhm2qMag>
    <xme:W6a4Zzn7qy7Te6OgcHjRqryNtH9nlEn393s28BNhG2TPYA_N5R0qVBUcXC_buDHFP
    YjDNr44D-n5egLg>
X-ME-Received: <xmr:W6a4Z3aF22Df3Ul4XCwpigtJuOD6Is752oTEE34xapaMiZCc4amV9Jou9dcinUxq4eJaev25CvKQGoWVlKcsGFx4TwLC-CVeeQCnz9SR_2_PnUvoDIc2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdejtdegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfhfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeeuhfevveegudegkefftdfhueettdeiueek
    jeeljefhkeduffeifeekiedtveegffenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmohhinhgrkhgstd
    dtudesghhmrghilhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdr
    hhhupdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:W6a4Z2VDCxm-m7Gf7FajTvmgZwnGLmDOeh2THGpqZLAr4xl-m9Zgsw>
    <xmx:W6a4Z1k0uLueyN2dyrs03x0fhduN-zVkrWthm2LV0SlkY0YNd8cUtA>
    <xmx:W6a4ZzfcaF2s4bgCKPsu3hcxucnoDMoeEEyAzsgWaSbrFuPkn3dSaA>
    <xmx:W6a4Z_G-0CJAbgnFaTgMvLfC31PZ2jyzyPawRWL9_F1U8jYP2och5A>
    <xmx:W6a4ZzZBVmfdizaT4sCYHF0FTen-PIQTb2TvZtP76GMPaPtrV2zOlpmS>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Feb 2025 11:14:18 -0500 (EST)
Message-ID: <9a930d23-25e5-4d36-9233-bf34eb377f9b@bsbernd.com>
Date: Fri, 21 Feb 2025 17:14:17 +0100
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
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com>
 <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/21/25 16:36, Moinak Bhattacharyya wrote:
> Sorry about that. Correctly-formatted patch follows. Should I send out a
> V2 instead?
> 
> Add support for opening and closing backing files in the fuse_uring_cmd
> callback. Store backing_map (for open) and backing_id (for close) in the
> uring_cmd data.
> ---
>  fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fuse.h |  6 +++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index ebd2931b4f2a..df73d9d7e686 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>      return ent;
>  }
> 
> +/*
> + * Register new backing file for passthrough, getting backing map from
> URING_CMD data
> + */
> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
> +    unsigned int issue_flags, struct fuse_conn *fc)
> +{
> +    const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
> +    int ret = fuse_backing_open(fc, map);

Do you have the libfuse part somewhere? I need to hurry up to split and
clean up my uring branch. Not promised, but maybe this weekend. 
What we need to be careful here about is that in my current 'uring'
libfuse always expects to get a CQE - here you introduce a 2nd user
for CQEs - it needs credit management.


> +
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +    return 0;
> +}
> +
> +/*
> + * Remove file from passthrough tracking, getting backing_id from
> URING_CMD data
> + */
> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
> +    unsigned int issue_flags, struct fuse_conn *fc)
> +{
> +    const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
> +    int ret = fuse_backing_close(fc, *backing_id);
> +
> +    if (ret < 0) {
> +        return ret;
> +    }


Both functions don't have the check for 

	if (!IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
		return -EOPNOTSUPP;

but their ioctl counter parts have that.


Thanks,
Bernd

