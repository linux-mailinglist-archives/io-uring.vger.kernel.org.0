Return-Path: <io-uring+bounces-9364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD77DB391D9
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 04:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C5A3461BD4
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 02:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631F22690D5;
	Thu, 28 Aug 2025 02:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="BjOwvKp2"
X-Original-To: io-uring@vger.kernel.org
Received: from out203-205-221-240.mail.qq.com (out203-205-221-240.mail.qq.com [203.205.221.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E038B26656F;
	Thu, 28 Aug 2025 02:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349350; cv=none; b=qMNjy0s8dBjJDV+Coa0C3+yN9ydBQRn7UOO14ZpVM1KPsQsIQcHjB4hjBhMw4g1uxlos/JLlA8C5ZoxkcucQAO+vwGyN6OO5H18wbkQY/hop4bhxdZikJ1bYt6/NOTZpPvLWYHa/5Mj3PBTKIrNuUphszkIkG4VmUmvHEJFoLfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349350; c=relaxed/simple;
	bh=+l5e+yZnrGb3bXqlnKyTSIz+c5M4ZmAuIqGgc+mW4VA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=prqEmXozc3qi1nSWtCK4w/tXqqAN2mxL6WWIvEYg+WSMafu2O0QlctswS2S1GV7ZYzGt6ws9I1QpNRio7YmO3c6WYrXn0qL5hfTyCRZ2b1GSJqSiSnHT7179qi5vPJ/NCGmKLdNwTMPdZER2ahFtzz6qTYUCDBzlh9nYYsA2DYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=BjOwvKp2; arc=none smtp.client-ip=203.205.221.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1756349342; bh=wmxu5LdA4rSDqEgxjg7PndpXoLI6R/s5pWckpsaV7Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjOwvKp27KlH4ro0yMKuL9WopRiXAkcUECgETJpsDs6GA5t6896y1AyX/v6UIpVcW
	 VBOWNtDql8TI8jyvLCQjsnLk2mP58AvkDVFGSbYTcVT4pKJIUj0QoQ0SS4/sgUD/JB
	 iOgijMk6fsZYZX3RP6lR3uiVs+bfsYcEovH2KFyg=
Received: from nebula-bj.localdomain ([223.104.40.195])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id C4034847; Thu, 28 Aug 2025 10:49:00 +0800
X-QQ-mid: xmsmtpt1756349340tedrwvlve
Message-ID: <tencent_87B68C160DC3F4AE06BD6DF0349B1B235E05@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GPlzj1Z0LI/Ag6NEpRiU5iY4Ga3CnwRNO0WjvXFHZtwhHVNO60g
	 z6Q/2jKadRpV2ypZboB/5Frged9JmLXNFEUInjql2WHdeI+GaBagCAs8RuBCIs5so3qKKM8dclG6
	 lkFztEWYTSJ1yqe1Ne0Q3IbC/4S7btKyNs7/xK0smHejzBhoiiIb0mn7tgkfSG337FE9i31RAurj
	 SgnTAOsN82yg/NbOWO/XHjiN/S3QK4wxzUs8EDIdqdQe37DrmqNs9n8TgKUHhZMcpxVi6Gq2qdym
	 KN0iIqmH+q/ToTOxLBWvmK940Bt15usztKTq2bBDjQLWu+j0s3NTzOqo4frkqrDfVtUIiiaMc6my
	 pwVAHmKpHWQJZutzKW4flvJ+b8E03K+0f6+684vpUQaCGz63TC+OoxEBWEwwt4l+OtEwODy5WSu8
	 LdQpy2pIO4M5bfTKHBdnvJtWpA66zJVm+oPd6wv8nlHwoNanvZvy7zCAIcUTc88n6M2VKrTPCmbz
	 NzOLBcV0lsZIFXQUT+hw5uWJPV0fKKZvl33buMKNQ0n3K6W1n8Fos1mzeQDvoVwM/SX6+dl542Yh
	 ZQIgWGM2t91hSAmj9nhPIx2fkIiINtyikmjsFHp8g3WrVMnZFT3m663WOWSmGkpuHmdaQZE40U7T
	 ECz3LVI6K6OZbQYcdV8AwotGAbaeluHA4Ua1zg9a4PHC5IkejHXwsLr4dNRiYzDbjFHCt17A2fkg
	 KbLKLB015yvc8GdAWHL9dxJFW4lJZCTKoUJ9H2NVLoiEeTX1tgYPvJIX2g/nlM8l/beWmBXA7Spl
	 C2MpGGR+zSAZ7wBghOTu0pe9gPj97r/guizHd2zHRkzBugXcumpbivENvSuC2T8TQR5zNxXQHQ8O
	 HfHeaPC3ziMQPl6kPHqnkjBdC1mqH+tLrIUFq2wR5D1v/0Ffk4J3y34xZ46bA9PKQxo2k8kSl7YD
	 la+JEvIMYLazffWgKxZvll7rKxGlclz87GYN6GdUCLXRT79huTf10Q+yIte3vXXrsjlU8O5VEN85
	 3CBcEQx7wpCnAGZxmNxzir/YBug6XwzUZYpXCS9AW6DJisZTtuV3PNVWAFlpUb5atkqersaQ==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Qingyue Zhang <chunzhennn@qq.com>
To: axboe@kernel.dk
Cc: aftern00n@qq.com,
	chunzhennn@qq.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in io_kbuf_inc_commit()
Date: Thu, 28 Aug 2025 10:49:00 +0800
X-OQ-MSGID: <20250828024900.76080-1-chunzhennn@qq.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <8abaf4ad-d457-422d-9e9e-932cab2588e6@kernel.dk>
References: <8abaf4ad-d457-422d-9e9e-932cab2588e6@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 27 Aug 2025 20:08:05 -0600, Jens Axboe wrote:
> I don't think there's anything wrong with the looping and stopping at
> the other end is of course a safe guard, but couldn't we just abort the
> loop if we see a 0 sized buffer? At that point we know the buffer is
> invalid, or the kernel is buggy, and it'd be saner to stop at that
> point. Something ala:
> 
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 394037d3f2f6..19a8bde5e1e1 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -42,7 +42,8 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
>  		buf_len = READ_ONCE(buf->len);
>  		this_len = min_t(u32, len, buf_len);
>  		buf_len -= this_len;
> -		if (buf_len) {
> +		/* Stop looping for invalid buffer length of 0 */
> +		if (buf_len || !this_len) {
>  			buf->addr += this_len;
>  			buf->len = buf_len;
>  			return false;

Good idea, it looks nice to me.


