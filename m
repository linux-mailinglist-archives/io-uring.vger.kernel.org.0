Return-Path: <io-uring+bounces-13752-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mLHXAlhxMWq6jQUAu9opvQ
	(envelope-from <io-uring+bounces-13752-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 17:52:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC37691767
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 17:52:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fdh7qqML;
	dkim=pass header.d=redhat.com header.s=google header.b=TiWSElTY;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13752-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13752-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9142630097DD
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 15:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3238A44CF2C;
	Tue, 16 Jun 2026 15:52:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F341344B69C
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 15:52:04 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625126; cv=pass; b=AV/rddxuDV8V5MQuT5HGXA7Cbh+AiSeEtZ2IW87SRcVcKu1HsvyjVEoQJgWQxYhxQeTpmcBsoQs1lKvSrQHUjefPHPLK9+9tV5bWu5AcmPzX0I1p6DNBFjchHWYgAsFcDuBYNIAUoiE4BlmInjRuFBFF/+Y2AEASJ1wMeDqcTvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625126; c=relaxed/simple;
	bh=t/v2XhOciaXaxeARA93JJntMTjj2WKs4mmt/RhlNnag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gs443/rpAK2qWnjZFrN6p8RaFlDCwhQwa4926IbFDShf7stiID0MhuUKgfT2Zg6EyhFgLBeOMI9HpOs5AIliw7XAantTXGhqx0QZdmqsapKCJIpkiJqhKs10z4LwbU2Mr9ENkTApa2lTlOYBde/gezJQtl17fu187ZkuW6KheFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fdh7qqML; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=TiWSElTY; arc=pass smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781625123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XDaE+NkQ9oDdXyWd6TBG0fklVtRq6errziGa0gYxt0=;
	b=Fdh7qqMLMnHxAQ8Bgc2VSd9vPsRgrTRtKc0IsoJE2jK3+csDzt9szAHP/bmcFP8EYpjKnB
	bbyFChYmCJJYUqzqt23XkyBdwDtI/nBnVK+3Q+mQ2fq3RoBRgyNAflHcpJmTzMbIcyjK0/
	z2icmU0jlMIOXN7Gzzw6rpjI+oVS2FY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-ozl5W2QyON2BYkDjiB7YMQ-1; Tue, 16 Jun 2026 11:52:02 -0400
X-MC-Unique: ozl5W2QyON2BYkDjiB7YMQ-1
X-Mimecast-MFC-AGG-ID: ozl5W2QyON2BYkDjiB7YMQ_1781625121
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-bfea278c439so28851266b.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 08:52:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781625121; cv=none;
        d=google.com; s=arc-20240605;
        b=GccmtfcWzI3/EYapzQREw8EzM4KKC33kTyhY41Z+VqwlvPnjvEVpcWOlGKTcOwWkvw
         Wm5uIdQKW7RD0bxiQYXMUeApIVmVGSzzerwzWCXx92AYuMiQkWs+44PR1cB7j4ox7I0b
         yz9gSsDcYFeiayE6kCGIDbl6LUA1aLFiHYRaSrypTv6ZlHOHm/C/X3DXcrZ7a++ci1Zx
         C98aXGfV8fqYxbFsuGElcmIZFknLe/r6aZsHFaV2pCg+4N90Iucg2sbxsd3cpnRvFK5u
         d8BjKlqW/R5/xotAcHxKMfmNLjlSGsdex66Le7DDTZaqekGJD9HdHf9Ru50p5i21s+0H
         x/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/XDaE+NkQ9oDdXyWd6TBG0fklVtRq6errziGa0gYxt0=;
        fh=yvxwayb0pPL6aPTUT5KIoQMcpCHqjEwyiEPRz4z3wWU=;
        b=AszyfVsH3/4wZbaoaj20yNxLJzTlO6mct9NoXmhIeoeZ4TzPmpLXaMh43iwY9FuwSd
         w7zb/0p4T4YRxS3MxVSVJZZeD+VL443TcnFTQ30H623SmSCmcoHfKbzttxDiNk4vmDPr
         tFwbXVbSz8OdC4D0XMS3Izr0A2/Q/NCJjZE6FNQA5o02AnD5qyR+yLUmBHyujtYjsZlz
         ejSpWQWj5snOzOB/f2xWVKkIhQwrDBqKuxuh/UES/b1ejOHk5jMSfdRTd2ux10AA3g0J
         gJnDy9Y9QR4Kh+/IzmhrrvnwYlyqLvRv4NS9q0t5fCFLoSVAVLzKCkcHbyvgwptzLhwZ
         BYSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781625121; x=1782229921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XDaE+NkQ9oDdXyWd6TBG0fklVtRq6errziGa0gYxt0=;
        b=TiWSElTYlbXBINUSJwZe/TXGJePC+coSkf9R96qxgGiQ72eGAXH8sNQ3AVic6s8V+g
         FoKPHB/1jVCt7XLKb4oKzbPj76wRkULVNlYv11IbYgsGwk34gAiRZmGLTcsbiYAKXKg/
         FVVQ4D541jtxA/bBiAcvLxNH1lLmNiWNx0mD4vj765LKp4mEdW/6Sm+osBkfqai9UyhC
         ghd9CKhtZWMZSD5elBifeHI8cLjHNoQNnVuNZ+cNW5RChcp70NTnoShgI5HW01m+G2Yp
         0U5aXfhOjjQjRMadNPHGaMwOmJd+W4IkAoomg51eal+BAanx6V2l9QYF+7TKLKKi2jUM
         /IKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781625121; x=1782229921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/XDaE+NkQ9oDdXyWd6TBG0fklVtRq6errziGa0gYxt0=;
        b=nPNEdFJwwXgWaxqhyhEbJJoMAWZtlskq0kkj1vMiqdqn9a6cWKiVsA5P74t4TPztH2
         acL8S6WEyWR3IBEyyOcoCYzbV14HYgHE8GQKa2LriggntDbhP85nFcc5uxdPnXvLvNji
         Wedf2a9oi4NHBIWvZVp2TZdkQlWvyUzkVZZrgnNSRpenz2cfzRxF1ReRgADxyNrvZy1+
         D57NgTviKKU8I+V+pzAyGQwod4mX6aDoIfQPJHPesYYTWUb81vYllG4T/t6lh1CJxwd9
         GaApObx3aAdY8S2RqWzonkQ8fb3/K57RPPUjWjyx48fc9MlOTwp184zGZlmGNJRSZd0/
         5zZA==
X-Gm-Message-State: AOJu0YxyVkfg+/GC/4SXTSwpSX0oBff/TRZ6T/iS2L1C2oYUm+1PZ4c0
	f4ULDR/Lxl7RX/O4w4yjR7SEaLT8k9EIxdFJsMv06Rzp0pjObsr7gV2c0YfMEA6MhPrNyIxWtNh
	T6VP5Jmh5uDTQL79GWkJZ7k4MSVSEt6FHhcBtjklShGYvK08CYSQfrGEldvGYFSKHtLy7Eg6+zE
	OC21Xa3RCgKI8mJGNXYi4pUB0jVNpFRjwf3S0=
X-Gm-Gg: Acq92OF1Amj5f8hziuLxhqCxtXr/Z5gQAZzZWUp9fkFDTr/mVCtr5PyZGhky4hR4o4d
	sGnoRznFVxtSh4zT+fn8eXPEspEEtrh87+QQ8iPuqT6pT9YeQFvvcea/ojzZL3lR6z6iMtPWj2R
	2ZzxZCoxN3NVj6eGf7qYZKPE5+yph6ft5KEcmxYyB3ZQ3xXnXaGOjN3zlH1o83YhWvhmtjymvi9
	JDJEfYsx+QyP5YPsZ2TMtKPMkSfXIl90oklqnkl+ADnwSADpR0yHfbog3dF3SQhQ1HTzYvzAsgg
	4ft0mtJ/3ujn7cI7tNLQTQwp
X-Received: by 2002:a17:906:4796:b0:bec:4906:44d6 with SMTP id a640c23a62f3a-c05a1e4b7demr21088966b.11.1781625121352;
        Tue, 16 Jun 2026 08:52:01 -0700 (PDT)
X-Received: by 2002:a17:906:4796:b0:bec:4906:44d6 with SMTP id
 a640c23a62f3a-c05a1e4b7demr21087166b.11.1781625120926; Tue, 16 Jun 2026
 08:52:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616123632.3209545-1-rrobaina@redhat.com> <178162494946.2184109.3179193650867699448.b4-ty@b4>
In-Reply-To: <178162494946.2184109.3179193650867699448.b4-ty@b4>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Tue, 16 Jun 2026 12:51:49 -0300
X-Gm-Features: AVVi8CdJCpFzaMNb7I4yd76uoqe603V8jRZNiI1lwAgWmlO9jMwGizwDIya1tQs
Message-ID: <CAABTaaD9QnHihQpVtXpROHgxYEx353iKFHDZRY3oxxtF59mJ7g@mail.gmail.com>
Subject: Re: [PATCH] io_uring, audit: don't log IORING_OP_RECV_ZC
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	paul@paul-moore.com, sgrubb@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13752-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:paul@paul-moore.com,m:sgrubb@redhat.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[rrobaina@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rrobaina@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6BC37691767

On Tue, Jun 16, 2026 at 12:49=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
>
> On Tue, 16 Jun 2026 09:36:32 -0300, Ricardo Robaina wrote:
> > IORING_OP_RECV_ZC is a read operation. Audit only tracks file/socket
> > creation, not subsequent reads. Set audit_skip to align with
> > audit-userspace uringop_table.h.
>
> Applied, thanks!
>
> [1/1] io_uring, audit: don't log IORING_OP_RECV_ZC
>       commit: bdc2fc388c348ee14b4f984ff75f2ea440cefd44
>
> Best regards,
> --
> Jens Axboe
>
>
>

Thanks, Jens!


