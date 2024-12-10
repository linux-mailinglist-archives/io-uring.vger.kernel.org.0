Return-Path: <io-uring+bounces-5421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8634B9EBB7F
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 22:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C35BB286957
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 21:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C6C230268;
	Tue, 10 Dec 2024 21:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="Vuvn2IUI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HPLIYFv3"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C0E22FE17
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 21:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733864767; cv=none; b=oPJJsCVgC4lYgUbgTvgvYn7gfvLoufH+LuZqQxgJXeol4jZvv1DYAKaNlsAahbCrZQcQznBludvZgmU8RkVAAMUJVk6EKkeTD1hUA8OV2QjjRmQMnSi82qoPh3jALGUTXNws9ixwHnbSOolWT1ifrWUwKLRzPZ8k159mqvE8hOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733864767; c=relaxed/simple;
	bh=+gOhWDoONSdCG20KUQeUhAwE8QN2I2+flDvr5vguhfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/fOyls8p1gdyynZWe+sRNFdP+yVRFeAH33++NUDABEqcpB6P98Nw+rkI1T3i92ZNq7991OCNDWTJMEAUDTM/g1eBHimGp+ZqpPyukbYar5BoXJ3sC70YrNqdOgSwjTUqeUAuWimEwayQ2fnkjQwuhaw96LMfeFw7JxeJb4Z0HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=Vuvn2IUI; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HPLIYFv3; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id CF1D01384162;
	Tue, 10 Dec 2024 16:06:04 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Tue, 10 Dec 2024 16:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733864764;
	 x=1733951164; bh=zrqer1XdO80Cx0S+KwaOfMLZ9jymNjSfLLZvG9uw7eM=; b=
	Vuvn2IUItWNS0NtbQKAt/qMu7yzev9B1njHnYii77AKgrrs1On+WcdHQJeKexBUl
	CrjUon6VV80wmU4se6PSLJ/TPwLBvlZyxUz9lo85wDgQXTGBALZXrKan2i/iiVBl
	I2BpOQj+4fVYvxNxdGTPuqkHmCf6FFWSV6M3YMuWsLLBvg6xk7YuucU2lPp/bu/F
	VUWw1nUNgyayoDxwfHH0p7m4yBVT2ZTNNYVIkTOjqQW++L5/zp/dOT3g/Z2KK364
	3YUy1h505Bj/IifCfb+QDHN8kmjSkNpaTpaERJ9WCKhKjFL8uigvN9qrsy7D0lpF
	Hzc5bwe5IhRyBn2QJW7dbw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733864764; x=1733951164; bh=zrqer1XdO80Cx0S+KwaOfMLZ9jymNjSfLLZ
	vG9uw7eM=; b=HPLIYFv3UnsBDHRcwxL0A+ZUXfeAQ+TCEAN+FwYKkd6nG0pn0BY
	CyW7H//zAgQEfc+I3eisvk3FMYLHD6kw4KYq3MhHqFSnE47a0wxVI4bFGlM/qBqp
	tfm+PsoeTJpCntD4LPlqlqHqsjjq4a1w6zbrDcyPJj0R3DFWnAIHQtNL3mmhLTGW
	DggcEDVU9/b/AvBQo+z4DZQEPuVzbcMkbyrvaCxDNu6gObtbxRXcMkBPtw7pYsj4
	O8f06YmplKHgMBDzen+doWYDBTXIZ8SgQUj22/7ty2uEJuUb5XZ/08v4MpIpLX7A
	n5IifNmhH53jLyKuslfPK+Us1D16P7J+PnA==
X-ME-Sender: <xms:PK1YZ3WzAnF59mBHHgybsNKKBPTFo3hxbdmxVBnei5zAajo4GzpgEg>
    <xme:PK1YZ_miM7kwBizdJ7aYXq9eASL89Dal12peiK-8WP6XjrM--Uflf4G0QJSBdZkEa
    PPXGvrxQWmjSdXieh0>
X-ME-Received: <xmr:PK1YZzZyVGK6W7f7tdPXhZVfmD1jXIlr1Vv-DLK9LZ3X3j8WYAv5cHUPSx0C2NvKifWL-WesdOPw4VMSox6wAjkEjs4Cag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrjeekgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomheplfhoshhhucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplh
    gvthhtrdhorhhgqeenucggtffrrghtthgvrhhnpeduieegheeijeeuvdetudefvedtjeef
    geeufefghfekgfelfeetteelvddtffetgfenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
    pdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehkrh
    hishhmrghnsehsuhhsvgdruggvpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:PK1YZyWRPB9EIHrjMuq4-YADPX94Tae_aEw87nLCfg60xDW5e75W3g>
    <xmx:PK1YZxnPkNdhj8WplYXtAfoCfU5WlfCuv4QB7ya8ilFtYtj9_lYmfA>
    <xmx:PK1YZ_c_q_xecwTBfLKegpfyqvG2T1Ru1lvMKnKr9NIBVYZG6gZTWQ>
    <xmx:PK1YZ7G3swwd0rJ2dek7EreBiQLPuPBhMMH93W3qyKY0ZCNt9Zcvvg>
    <xmx:PK1YZ6AryBLwVIgO7hmMkUeWKiDTVStPllvKLlhMbwgZwTPiZGF1Z-n9>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Dec 2024 16:06:03 -0500 (EST)
Date: Tue, 10 Dec 2024 13:06:02 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC liburing 1/2] Add IORING_OP_CLONE/EXEC support
Message-ID: <Z1itOpICd4Lrz-36@localhost>
References: <20241209234421.4133054-1-krisman@suse.de>
 <20241209234421.4133054-2-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209234421.4133054-2-krisman@suse.de>

On Mon, Dec 09, 2024 at 06:44:20PM -0500, Gabriel Krisman Bertazi wrote:
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

One issue noted below; with that fixed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -1229,6 +1229,31 @@ IOURINGINLINE void io_uring_prep_socket_direct_alloc(struct io_uring_sqe *sqe,
>  	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
>  }
>  
> +static inline void io_uring_prep_clone(struct io_uring_sqe *sqe)
> +{
> +	io_uring_prep_rw(IORING_OP_CLONE, sqe, 0, NULL, 0, 0);
> +}
> +
> +static inline void io_uring_prep_execveat(struct io_uring_sqe *sqe, int dfd,
> +					  const char *filename, char *const *argv,
> +					  char *const *envp, int flags)
> +{
> +	io_uring_prep_rw(IORING_OP_EXECVEAT, sqe, dfd, filename, 0, 0);
> +	sqe->addr2 = (unsigned long)(void *)argv;
> +	sqe->addr3 = (unsigned long)(void *)envp;
> +	sqe->execve_flags = flags;
> +}
> +
> +static inline void io_uring_prep_exec(struct io_uring_sqe *sqe,
> +				      const char *filename, char *const *argv,
> +                                      char *const *envp)
> +{
> +       io_uring_prep_rw(IORING_OP_EXECVEAT, sqe, 0, filename, 0, 0);

Shouldn't this helper use AT_FDCWD, rather than 0?



