Return-Path: <io-uring+bounces-13405-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sEkWIosqC2pAEAUAu9opvQ
	(envelope-from <io-uring+bounces-13405-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:04:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D6E56F859
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB21D30B9C69
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BCD31F4C96;
	Mon, 18 May 2026 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTaAdhgY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E4264A97
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115672; cv=pass; b=XyvdC7IFSLN3MBfh9ZMneAwnaZjF+oUVngXmCchjT8F6Mhj+bx7am3WlovxNv8N8DhHeboKwVRpFfAnzSRlfi3ruKVgiWuf3ek1X2PNkV9ReLsb6UFuOq5TtRx8YjgXIDCiUiaWIDgf7oSlaLecxxGeIQFNqZzEsM/Wxo7f7gbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115672; c=relaxed/simple;
	bh=AZ823ZQyhvXGglgg34wQlH0HFFnb0cd+Af1EN7yoWTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SWZ5BFNHnTHuFXTvwuEFn7X2usaKoscZ7T0gy6oHoA2hAXTqtP/VhBOnqX+C1kSLl9WzrOJFfDZxDehqK3HAI+rcpwj8KpNJNFa7LOEQoGOQoJQVruSxe/HElldOFaG7Ld4iGQtALfuLqQ+Z8ESQ64v/1XNV5bgowUwESzP8f+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTaAdhgY; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-654672a6d68so2412574d50.0
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 07:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779115670; cv=none;
        d=google.com; s=arc-20240605;
        b=busNrtpb30bYDiUi+vUubixtICjQHpfSTf67z0obFcgin22oRAo43rrJlfQqRBejVO
         1JtzG6rbXAGmNxckxK1VpA0iDyy/iZxpV6S9ussj9Py9JHybqZokwKdO1PVg+dGsN7iC
         r8fNnALJeJdzvYC8vrkOKBMGCSm9Jwk7Y0W/p1W5n4AcI3K73aBGB1/0FRxftaInWzm6
         xaK2gc8nENyF4aTj7CLRuUNo6sG1zfzRvChYp9oJR676g2VcZjvptlF/VLsWpQOYF1ib
         jCB7K1prUMr3eP9KJJecp5eIHuMB7YBjN6+i+QbjcedGCmThlcQ47zlF5ByZCovS49pc
         kOiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AZ823ZQyhvXGglgg34wQlH0HFFnb0cd+Af1EN7yoWTA=;
        fh=TbTCxkjShvjugPN4Z3DF3UKXuz0Xjye/iKNxcGMrnP0=;
        b=KHy1kIYzHwVOmhhEhhXWC+J8RUOb4xJITex7yLok+vJjK1nHv0XRZVwIWRUVucRdUl
         fI/ki4Xd2qLnjDr7KLDCzzYZS4xrlBDfikXXq5RbXfNwBXvB/6q0n6t1y3HUy9SNm3tl
         Vlop6SlDIoG/gB4Uke16Ct2b+JGBbYWfCJ6Fohtp0vd1yiE++YuL7dsYAH0b/a/sY3Ja
         tEpeXDrHwGVVOpYCUYei4eeD6NhGvqnGOekmfIzT0QLMEB2Bxg4zO6wuWFFlt9brdiaF
         DkJgMyYEyuGmS36ulcClYCIgCfkamU8ySVYwE+YU13jxsDNVSagRMNYVxODFPdLYCaX5
         IbxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115670; x=1779720470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZ823ZQyhvXGglgg34wQlH0HFFnb0cd+Af1EN7yoWTA=;
        b=FTaAdhgYh4AMvxycRc44LCKFgt8z+/yvOKDFXryOvMJT5LxB+L6cFh589qHNRIyQXC
         D9RNWSR7dQRtCwvhY3xztNY/2Nx7FoWkt14Dkia3lsGCK3/Nsg4eA5Jp0FbOUPvjcwAH
         eVMvXsdFDL0DMo2ORHSKVMChcCz8BmBpzBe5UJLEjPH1sEXXlv4Q7EiaHbd/unvA+HeZ
         0xMddO9pkb6w4JKgOw2palafQtpy8GkiYEQ1tKY4pSqWu41gZot91w/Ijxkvbb8IbvFs
         7hH3zfdpLXkeKtpWSWaNpnIkIJTKhudQqjkj/s9XslO+ihZlGCkL/xxbgKhamcUm9yoC
         xXPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115670; x=1779720470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZ823ZQyhvXGglgg34wQlH0HFFnb0cd+Af1EN7yoWTA=;
        b=NFVZROtJPIUfiOg/f+RyDBCGzMSdfoyCZ6CkhaNlCjmnBCYUZGblMnsccluMUyvtnm
         8Z6kHJr+zpQ8LZilI0opQCRJuNUCpqZMmoGcZgxn5RN2kug4C5np9n0b2be7OobFgkrB
         VxP/JGTLyYcOKAguViV3oxPTu37MS8ekUOGI4fp7xzm077dR5TpuB6w9auzAWd4dIOMT
         ra/McQni7PXeIgL1IViij0IIZ0eNmUPx74w797Pb6JWAyVs8G6acWJhfTO8OHS52aA2w
         3CLqL7lZBPSu09GIq8P1vTpDjJqLMj+GcJIrXz5nKi4utbD3iWN9WitcUN68zsNRs4La
         j9fg==
X-Forwarded-Encrypted: i=1; AFNElJ92bVdUXNZX5FNFeXNjBr0EwMooiAiB+fkAxpOzokCZaImJnSHtnFN7oO4NzS5CuYBLm8i/FRdu4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEk0tSnvSpQeAzsqNotfEws/sEbRHrinoXaut0oqkNVV1yMiIR
	M3qMAyYxw922sgF7jRBDT54MTLzUy5Kx4eeWzk9+oNqrztAqvO8QzVXM1q9w/E7kKYWQbDuUeiP
	7BAwsLPZ15l+gSAG4xdhKKWRzGrusvL0=
X-Gm-Gg: Acq92OFlf8YmafVuNvGuoNrGK2nn0asB9uATtK7l8j7I4WqEJUr11dymOr7/a6dF0cb
	TzycDPnNTkltXBJMeLCJjUVT/IZ7AO5AT8D1yrgdM9m/SFtEDZOFl5lCBacKtVznYMAmaD0NhPQ
	wUeb8q0ty9vpqoAWPYwBdr+T8H3vRjoYqQXGEnV4KPfh/G3aHisqhT7btM/BFsNp3ltzV4d5CcM
	s69YOEOsipCvNtjXeZFwC1780hth73xzT2jk6tYuk8KR6324eDiNhjAMgEcwYJ0cHCwILGtEO4b
	2nM5conjkaTGxS9+Nav6JLLr4p+l4b+5gliY1Wz+MSpdhdE=
X-Received: by 2002:a05:690e:138e:b0:65e:2532:b52d with SMTP id
 956f58d0204a3-65e2532bc6fmr15526281d50.23.1779115669804; Mon, 18 May 2026
 07:47:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260517213010.696135-1-michael.bommarito@gmail.com> <CADUfDZqJYvQEuUdWeqxvcBPhfj+zvsezcsnpbK0N9cnBTqr2qA@mail.gmail.com>
In-Reply-To: <CADUfDZqJYvQEuUdWeqxvcBPhfj+zvsezcsnpbK0N9cnBTqr2qA@mail.gmail.com>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Mon, 18 May 2026 10:47:38 -0400
X-Gm-Features: AVHnY4LpXh5POpaVsk7LKZiBIdwJs4joTfbMmSCDI0RleJUpcVZ6d2a4ORgmrUk
Message-ID: <CAJJ9bXxw-Ne_PiqHeXYEeJ8Gw4OLDf0fS1nq5mV4qC=CXp2GBA@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: propagate array_index_nospec opcode into req->opcode
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13405-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com,kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[michaelbommarito@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 03D6E56F859
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 10:43=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
> The local variable should improve performance, I'm not sure removing
> it is a good idea. Due to the intervening stores, the compiler can't
> tell that req->opcode is unchanged between this assignment and the
> later loads, so it will have to reload it from memory. Can you just
> assign to the local variable opcode here and wait to assign to
> req->opcode until after updating opcode with array_index_nospec()?

I'd defer to you / Jens / Keith on this, but in case you haven't seen
it, I was just following Jens's request here:
https://lore.kernel.org/all/0f7e9184-f317-40f1-b366-d8582cb97ac4@kernel.dk/

Thanks,
Mike

