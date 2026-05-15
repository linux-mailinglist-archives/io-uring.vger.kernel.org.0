Return-Path: <io-uring+bounces-13359-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4M7qGhovB2qisgIAu9opvQ
	(envelope-from <io-uring+bounces-13359-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:35:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD33F551837
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D32D1304C8A5
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABCF73B3BEF;
	Fri, 15 May 2026 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="g7er/OD6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74163B3C15
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778855363; cv=pass; b=uYAWG7ZONBuGPD/GvhELNP40CbhD7tzIZe7GRZ6ErlysFe9VSXpXckNFuXmnQnttruiQ7G61Dd0w0HmY7Oc27c1tLznGS7+LQ/tKLrKMteDB4HhMadEu0XwuFD6F14qA8Ka0KMaPxOu1xiE8RWObbfTHj+t4kwzA1/ibBydWAuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778855363; c=relaxed/simple;
	bh=dP0dHvrHOos0cd7ep4x4t15zx+uD33SpmwZ8H2CSkSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJSJx3GoNkwJfu5vs6vZEJoXZLSZ2MUZ8rz2wTwLI5FVjLwFwbD073VB6agCSL4MKsSAF3IXFw4CU31xlvDp/s6pB9HZIJs+cQCi4pmQrpbdQ7eG+rvbWhG99F80S2cDI9SBip9BJI5aaV/A2UkGdM26iwOKqktv1+PkOw0qPqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=g7er/OD6; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-651c5d525f6so12930666d50.3
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778855361; cv=none;
        d=google.com; s=arc-20240605;
        b=KULbnmNGS96Fm49ykLL5RGBb2iP18esk+jqUfO+eJWOOW66/DZCPmTlnXbN2k40tnq
         VCWJdKS2Vv6dvWQOjl05arpqP2FfSpw6oYs7bxpQHjuYtuj7znLVCn1u6XVQDu1HPWaC
         QKZzNkAP1bDfUW5r0c2bN3Ro05ULAQQqq5PC37nO2jSx44oACRrlCPG15QuVEI7pOn6B
         u67Tyh7hvjbrG7tzxLcC2C9cVG9mf0B8zTQCPe/21PiWx/u0+RRvfjPESxXoNoiz83AL
         iW7qlbfI2fw0tz0Rb5N8ITlZ1G0hsBHsq/oZKRlLzsLO7mbUcelD1M582VhPjMAw23jX
         QYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dP0dHvrHOos0cd7ep4x4t15zx+uD33SpmwZ8H2CSkSQ=;
        fh=3t091dg33KZsY8Ohr9Jl227i8rUFg+u5nSWxS//ksz0=;
        b=JWL89Jf6ZGnCfiIKP5fLNfQu/1fY7HMe+fNQLWtzmyKG3B3OTJhHG09bfhA9Ikji2K
         tyM63abffDiCvKc4HK269GZ4CIHwDU2H+WZ8MhpwIOXs0jz4I4BvZNcpTEOS+OSO4Pjr
         Xp7PAYczDupqd9Fb/oBrU4G7d8r+oU2GuHeiqKLZgxg1K/q5YJXaTS7M8e1pmfp6JQ6x
         MiLpDpm2IBFci6yde7aVAO9srMWwI4LARQfItyRwUpghjByg+U9vCXMphOh1wPSmkb2V
         LMA/KKvi5MxYyAGp8hfDIH0oBZjjL1I6Y1hpghIjGn3eJKlcAbrGKEHrK0YlJ60mOAZb
         GThg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1778855361; x=1779460161; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP0dHvrHOos0cd7ep4x4t15zx+uD33SpmwZ8H2CSkSQ=;
        b=g7er/OD6YZ7JaLMdsun00Xh2gzqZSnvOC5wd9LBfuFRQ4cuLrABBZO1FA3SicX3KFm
         nx2yJjOCThEe7u8xOyr6u9Q+qjQHoV2V62uvTw911FPuiMv40c38JIJm1VzuvwSFGEeB
         ZuViisxD+31HEGrTCeZvU81BvqooJwtICL3KGilfc7+dNPt9y9Utg8jILIcvGdPRLsI1
         2/d+2JwjQ0NFWqnaA+cVRSo3kwz1iBXNodEvSVkebUfVCzFjSFJPL4fN8V1PRl/Grztu
         ki/q9a3qFiIUOcQa7raNM36FSPIS3jP+Lc4JDq8kJTnWbfu9d4aHOaXWrXsihiCLKuyl
         espg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778855361; x=1779460161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dP0dHvrHOos0cd7ep4x4t15zx+uD33SpmwZ8H2CSkSQ=;
        b=H45YQ3xDA7uCZ1V5Nn0rQHnH8Aro7Oy30y+aJjARZQeibG4yIIcRRdqThFkZ5dR5Ur
         FnsQivRcY64/Nbbbbdtg8gl6zczXO23a5QPAt/jlEaffTHm5msDtPgioqTYMmWMNrp1l
         VMGKqPEZNa68WMjcnB9IZzw64lu3AHHmAThXS/MPleB4+pfkLsiExD0AqLZqxc9JTyJd
         B+Qu1wBFQdukqIRHfOiJo9g3fP1r5xiNxyvBBPEI+N9y5C/Vl3TU0x37/BW6auYGATjv
         yPizr6PA/mNHXBWAtPKo3ldGmzGcZP3z3a6Rn8vatABTmz/HHJnmSrrLX4i1GZFEjBd7
         Tz3A==
X-Forwarded-Encrypted: i=1; AFNElJ8yfIBDJowf+iISU007/2+14ISPCTDPqsMXAMCRgETAhuVoqnRjBUUQTJDIGzzTmLRJL2vvywmV0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcugqm7EuBBcUw9dtnLPZAFA+UhZFkjXujVEICj1EZvBjy2jGb
	fuBTTaut1XE/TJUjJheSpw4iGteeYgo9GCL8fsnUSyk90iQDPMWWyU428IJLbYfRC2AulalveRp
	ernS/6ALDDuP0zzB98Fy3WqeQDRlC6wO3EBm9QDPaVQ==
X-Gm-Gg: Acq92OEylMn6vFiYiMnUu9hUp0YsFomMnxHen84YlHVdg1YeHIVaS8IYslhY3lwwNBB
	DI3tO/tZ1cqT3Sr8Dk+cqGbVuE/AOwGFGOLcA05jCALvUmqBDGUG82j530bb2c5ovtPgUVl7R4t
	alObvPnAT6jaoUCPR5OVwQy+MipyJLd9rVMPb20MSnucGUI0PdYm8a/iemF17191O77nQkrCaCu
	8tlnx+ydHf4YbYavpeFyzkCfwSt5Ha8X2NKLugn15H2XJulOdd06k7XI1yZsxsnygJoA/WgXb25
	qreSiTa6XltL8RJgipNQnDmEZebdE8yhRVx0AoGt
X-Received: by 2002:a05:690e:1591:20b0:651:b477:71cf with SMTP id
 956f58d0204a3-65e2280d9f2mr3577169d50.31.1778855360752; Fri, 15 May 2026
 07:29:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515135903.2238731-1-vineeth@bitbyteword.org>
 <20260515100448.715589f6@gandalf.local.home> <49e77605-6227-426e-8103-329474bf88f9@kernel.dk>
 <CAO7JXPg+MJXF8smC9qXs93YziJT_amQwWKVW38L7F5XdS9-SaA@mail.gmail.com> <e6e5d079-25f2-419c-a992-5651ecae26bb@kernel.dk>
In-Reply-To: <e6e5d079-25f2-419c-a992-5651ecae26bb@kernel.dk>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 15 May 2026 10:29:10 -0400
X-Gm-Features: AVHnY4K6QwXkYzOlWsg8Ut69QpegiybtYTjeTkJ0n8psR-YW3kWPDDSPswXxZJs
Message-ID: <CAO7JXPi9Ph_e-MMxtcbhfU5Wm1i8VA3gkHtsAd5-Gd2uK8GZVQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] io_uring: Use trace_call__##name() at guarded
 tracepoint call sites
To: Jens Axboe <axboe@kernel.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>, io-uring@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DD33F551837
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[bitbyteword.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[bitbyteword.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13359-lists,io-uring=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vineeth@bitbyteword.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bitbyteword.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email,bitbyteword.org:dkim]
X-Rspamd-Action: no action

On Fri, May 15, 2026 at 10:25=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 5/15/26 8:14 AM, Vineeth Remanan Pillai wrote:
> > Thanks Jen :-). I can probably send a follow-up email directly to the
> > maintainers to prune this part, similar to what Jen did. I guess one
> > more version might feel like spam.
>
> Jens...
>
Oops my bad, truly sorry about the misspelling.

