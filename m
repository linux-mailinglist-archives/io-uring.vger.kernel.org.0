Return-Path: <io-uring+bounces-13647-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id YIHPKi35JmobpAIAu9opvQ
	(envelope-from <io-uring+bounces-13647-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:17:33 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4C3659255
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:17:33 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=janestreet.com header.s=google header.b=XXcB22Lt;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=iEF9RcsS;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13647-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13647-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B83F3004C06
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 17:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70333CD8C9;
	Mon,  8 Jun 2026 17:17:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABAB2EDD78
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 17:17:28 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780939049; cv=fail; b=O658TvvcikxQdhdcaMkd4Zg9OMBvDenT3woweFQ2DBnrPPHRESfuJf6DxETGUFYDLcfiGIp6gsJiJIEVuIGoM+exZQbB8dXru2+ozakH1aZNtcuzdHk177SuaMe5nQA0hi/sugC/E2aFjHeXsGHbzns3YoUXulJZEgsvSIEMFqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780939049; c=relaxed/simple;
	bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O/9vA/zXTGihIJdfOvo7JiJFYWeU/w5SA2mfesijg+1ebBvOYjl9n14Zmb5ZCTSqak81qHPtZEb2xV+82vjgJpwwVVSl+Zubw0ny+I+tzBqOiEKb06L7m9ZmLNXVwslK0rGus8rA8TeVbbyzN+sq2AvvFVKkbrhWl/SpRXSRJwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (1024-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=XXcB22Lt; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=iEF9RcsS; arc=fail smtp.client-ip=64.215.233.18
Received: from mail-ej1-f71.google.com ([209.85.218.71])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1wWdbG-00000006QtV-2xsR
 	for io-uring@vger.kernel.org;
 	Mon, 08 Jun 2026 13:17:22 -0400
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-bf523a51c24so191851566b.2
         for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 10:17:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780939042; cv=none;
         d=google.com; s=arc-20240605;
         b=KpYk46eqspiwHdcgHj35LJ2wba764lC6pDIj8At9YW238cdwqoVmUwi6jZTujC7rTg
          7ZhcWlBDLPzdyD6m7wTYOR2hRA6HbPgvyorU2Hmuhe5yySdQKTqXpIWmDUtCL5X90Imo
          RkvTdrYOev3CI6r8f+U9nCxLfT0YHuCe7KS0NEL23my5sqMoPQGtrMKRc12kMX5by6ts
          HlrvBEr+Z1mm9u5tayPQAywb/4PSd+7KPMsNdZmSsTvqwGZ1hS1sbtcVvv9rQOy3R/XX
          W7jIF8PLHA+wIih3rbl8/K/4B5pHmwT82h4nOs5Lq7bAZ9icb8kAVzUAL0z6n1G9Tm5j
          RvVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
         fh=YAepXsjYFkWKs6u0VIAptqyGQBARpQhKWXc80ETS2Sw=;
         b=FIXOIxITwonDCSMvRL0meTzjXncKNH1O7kVsD2ON3r9gZlMtOh1vaW0dQt4huBk0yf
          QQZdcRfNac70WzyBsfZp42LwYxsI/56Rqcbh5S4a7NnUBPdKwrZjigS4o5f8OgBDt+ix
          XomIKcY2qAHiV0kuYLjoL3on9BHey3SxkcJeS/KJ3qv4PKSQp4vj2BllD9YJ1QxHl3OE
          EiQVREYZwsXJBU2bgnS8vAQlGoVigDlph13drl26LHvTPecmHBhraAdqn0QZeKBcelXw
          qEGSyq7uJIl1rmO4iB14P+xXLVhqrdBIDLaFukitGzq5WWN9mp9QUG/eigoBExipUrfV
          ILqQ==;
         darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1780939042; x=1781543842; darn=vger.kernel.org;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
         b=XXcB22LtEBzsh1FnSTtwXA4PQX97VVdzgkwsMoenOMe8iiJeoX4Tz9ZqARwvw3ExsE
          x22P18IubQK8L+O6WHC/36u+ayUgmmPluBmeFKmwrwDQE0TPVbMEe+TiHpfANPJTKgSG
          nJT78VuOl+/Ahv4bNHmatz+RdxhySgBInpZwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1780939042;
  bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=iEF9RcsSVUznVNnTsCCypCI0GGTTr0aqGDIQelANpcqz1YD1dMTzOqyHe8Tc/1SZb
  uuVnGMN6wLAIQAifDYRR7vKISMCtL56XmY+8Zy3q15ursCo+qXSD4WIrn4z2pht1+2
  keSAGpV1H2z7C5233YiaePDrJ0DGUA16NZrlPj8KqQjcjyaCpwVzzSCVkgrR0Qh8qG
  AMzCv0vJ8sBkzyRjAl/1xt1d4XKoyYF5AqISfRz7ma2kkHezI/bOYZs3hSgGCfDoba
  6Bip2Kvp2DZOfFhylOnHdSQ+V8eHfwCpy55DFOe51Ci6aAlghHh6ANWQtX/WiST9vK
  +z3enW0HS6dqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1780939042; x=1781543842;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=nviWi2SVvs6kP8+AcZcCp02bcOI3+H6tiI/C6wy+oDU=;
         b=i9+HIazY1QEXGQnW1tlxVt7MvZVzbL5ilKMwB2p8puwCJXUbbg5hKIH+HJa84mRgN8
          0cRQVq7goS1Ah/RfX0pPzIVH1HW5/PAFBy/kS+H6PQoXa0p876KYsUsX7NFqhNzhcqkf
          mV8FlDfY2JLf92/Eh1ryvtIhLpqv6I1yKu+yowPeMBDghbZwM7FFfleJdBKPMxBG07qQ
          k5ITOKBmlQYEW5Vkf7CoShFH/FMqNnFtr4Au9DbmdHjim4jRjsbDTn/2WRsnJjzUlAX0
          mLboJXY7C85Sidm5TdZOzdcW/r//sPT1qXaNVhUqU17xfUgS92e6bjhpm9AwIOTEMG/r
          y+8g==
X-Forwarded-Encrypted: i=1; AFNElJ/v5N8dQz1jSWDDrI/Y3hvHnusVMvyqSG+kCAxsNMjPAgZ4qvMdyZYJ0V+T+XPryeJGIykPrIRlAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2+d/w6szuFx2QGdXwMdTFe9EK0H2+RPAB5NKk9PrJT75XzFo6
 	0utAjgrFel/ZQDxNQViaIYcI3ARSbc+cgicTy91sskJZb08lC1Iw6r5GlIO/hhTTTgDf+gjZWkN
 	stde9AP62bJNOUFXIyOjZJ+9vRlKXnfoHKeyIN5g4pMp1Ii50oDCm6eXVMxsb/zwmS2lS5giYIf
 	f3X16iYNCMOgtTFWClp5kgAV8OS2WB9bkx+w==
X-Gm-Gg: Acq92OFbnw/TAotd13jVBF8PcIfrz3lc3BAo6OPxh0hyIcntovLA+sj11Qh6e8V29hk
 	tGlLJfNizEhJQU3jDNb0bpqqZiSMrv7C+Lw/jrwTUZmMXRXAsh2CQx9bXZTxQI6fiJt0jmDyzLx
 	TjH7J1OFZdf/pZt9OdLyvUWGoVVQL9KvnLgYeOGuEo5wFKuQpWFyE7SAT6EhzqXtSFzf4VrkXSt
 	ZKpaiC59YfjGHeC
X-Received: by 2002:a17:907:6d05:b0:bed:afd7:185 with SMTP id a640c23a62f3a-bf3737ed359mr795417366b.43.1780939041653;
         Mon, 08 Jun 2026 10:17:21 -0700 (PDT)
X-Received: by 2002:a17:907:6d05:b0:bed:afd7:185 with SMTP id
  a640c23a62f3a-bf3737ed359mr795415166b.43.1780939041283; Mon, 08 Jun 2026
  10:17:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
  <aiLxe-9Sub8cI3Py@bfoster> <aibns0xP6IVVNWh3@bfoster>
In-Reply-To: <aibns0xP6IVVNWh3@bfoster>
From: Eric Hagberg <ehagberg@janestreet.com>
Date: Mon, 8 Jun 2026 13:17:10 -0400
X-Gm-Features: AVVi8CcZJIKOxJFnY3us1cFaahXNeQdHGkpT9n3Gwe9O5wCWWT-jbuC6519peWk
Message-ID: <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
  re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
To: Brian Foster <bfoster@redhat.com>
Cc: Gregg Leventhal <gleventhal@janestreet.com>, hch@infradead.org, djwong@kernel.org, 
 	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[janestreet.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[janestreet.com:s=google,janestreet.com:s=waixah];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13647-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:bfoster@redhat.com,m:gleventhal@janestreet.com,m:hch@infradead.org,m:djwong@kernel.org,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ehagberg@janestreet.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[janestreet.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ehagberg@janestreet.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,mail.gmail.com:mid,janestreet.com:dkim,janestreet.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1D4C3659255

On Mon, Jun 8, 2026 at 12:03=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
> Another idea that came to mind is to try and just replace the -EAGAIN
> return sequence from the low level iterator with a flag that triggers
> -EAGAIN from the next iter advance. The idea here is to allow the write
> to return partial completion (i.e. so no iov_iter revert) without having
> to return an error from the lowest level in the stack. I had claude come
> up with a quick patch [1] for reference/experimentation.
>
> This is based on v6.12 stable and compile tested only. It needs more
> review and testing in general but might be worth throwing your
> reproducer at if you can..?

With that patch applied, the reproducer runs clean - no errors - and
gets roughly the same performance (maybe slightly better) as when run
against a 6.18 kernel on the same VM.

Thanks,
-Eric

