Return-Path: <io-uring+bounces-12606-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCk7Frg5r2kPQQIAu9opvQ
	(envelope-from <io-uring+bounces-12606-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:20:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C418D2418FE
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BACF53016D2E
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 21:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7FE30EF6C;
	Mon,  9 Mar 2026 21:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOATCely"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7CB2DC76A
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773091253; cv=pass; b=uQdenn3hXnqA6McrCUn6pQkHCcXubZxJiwsaj2qc6oWztsFfIOWEJoc0KuHN/lgk3/BI+D4qzEDpqKpJSEKsr4V3GEj/HuPyftoIezZqzdGbWx0ewX/um2jzc0ORCH5qreV76QrP3QBjnpr6goEuFGfPcObUatGMC/IZZFkfeC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773091253; c=relaxed/simple;
	bh=qXLTkV+uEX+QmCtMLBWougKx/7SUexjbXNtQuSgvLjI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ye5+25VDLnJ5Uvyyvh8qSCkahVXJzUpmccaCWhXGm/A1vEJE9TvYSyT2Yo4xiXfSuJad7BrdDK1MmMCVBP67UYYcNvZDIhTzGRUFcy/e9nmrNwe1vMrX3cxOXPHa3kPFBvSkTwB2Ac1mzKBjcT4KnHaOMyuOW60jzkgMz5vgie0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOATCely; arc=pass smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d7439f8837so951992a34.1
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 14:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773091251; cv=none;
        d=google.com; s=arc-20240605;
        b=Temun8tuTXIO65cQmgs0uVSnqwmWuHTQjZf526QsTxs1Fz31yQqT1ZEldfo2AmPULC
         3Su//hgVdACB5qU7w7sFd33UOGOYvEWWMh6JbZYt4kto3XDoGFqd5uSGSND0bIDr8EwE
         Pssc3Ch1SV00oagvAAMOe91xMLED914j2CTi5NQbPvevge94eUQ4lpbBYjKUhCENCj6Q
         Gju7oTc3xw0lD4VoKteGdxlTL3w9+I05UQ7oXaHMzf9SPAyragfQ6pTE8lwywK3AV/8y
         0oGU2wR6pIpobW5YBugLrfnniXza1KMMJM2KfD4alSjMRt5HKrlGPqtV34TNEFnDqoUj
         MNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yaepv3GmhMbaoVt32hMi67NEGGcd9G88eyAfz+KoIkM=;
        fh=m8vGm7Or5csP1pBA2jT9ww2jpqGXOI9XeBFwpQKvcqI=;
        b=Z0uTun0+4iLxQ5I7Mj4Q55TwbgLxYlI0l554HW/Hc3fqd6YT4mKwnN/rGceiOI0msa
         +4A9VqM7IWNp/yZBay4nTfiCQd/S1avlZlngpUoa6jT7HFWkwFamgypaBo6QE999CmCh
         NbywxAtK/WngAjRV2kZXrrg00uXjmAwqk1NLhI1Exi1TQnpSRtf3h724jPnxa48yIEgC
         dfNY2Y4BR8fMcXKetI2/lh6xFudM40pFUKAbNpZdEd4cuDrB+PJUKw+euL0ZDtinUr7W
         e0FUaMT1+FfKcwMB/KZ2EhhbWI3rk/JlB103bn4iQDXKUIVaNelfiFzyo14D639LyKl/
         FzeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773091251; x=1773696051; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yaepv3GmhMbaoVt32hMi67NEGGcd9G88eyAfz+KoIkM=;
        b=fOATCelyS2bZdEG5Ksn6OrT0uC9p5+1dAqEIlo5RkmkAGElvJItgTZy1kIL0/W2Yg4
         Le3LssNsMmIQ82r6A5/i4Y7ZWxUCjGC7jDjF54y2J/tMtIho1UCSl032AtYMz78OJfrT
         qlnlF528sfF/GhHxQqYTstuoK8lB+C6G0s5nvWFuUOxpedL9cXl5c4yg5W+W8BFwORug
         maT/R2J299bfGc2/lNU/55OLKzaQOxkcmgJhCeHY+halGUT1EeQVOT+035RxmBenDlTg
         HfgcEH77A1rpIq58eppKUzMm3n6Lj/s+M+u5R81K+K3q4V6tiVyW930G3YxdaCbhZxYi
         kl9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773091251; x=1773696051;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yaepv3GmhMbaoVt32hMi67NEGGcd9G88eyAfz+KoIkM=;
        b=fpLvO3t5jHST9L0vTdFzNqVodJFd+7l4uPE8PNnm1V7M9p9wndP3S5kGG8WjKzvjRB
         GouVRWqrvC7qJt79mZlx5FU9irS6zHw8dvaXJegP2JHufGJSZfZE9lKeGI9emxJo5I/U
         JP0vrC4QLp9JyxqVaLCWQHl91hShpcLUbkT/iLmTUCC53tanzMz+FjHFAHkoKNmlLcFQ
         NRQ4C7JyML0JzdPOipZPaSdms9VwysZCYuibxt0VqkgniSus3/01o10Qa+wqQkVtV7YG
         gF2/eWOw3dAH5dB3md4OnEwDxrOGxTmvLE25/3qOANu+D0dr3gqBRQbN+ZSZ2QWJTLJg
         RIUQ==
X-Gm-Message-State: AOJu0YxQYYmxECyuZ34rh3TjNwbPh8WC6W/vopDCiDn/CDl7yWBwgxm3
	JXgM2n0n8ed+5DuexcoNgpOHgyP1nbxZTkwnlmswyJ4LgGyAKUMD7PkGcDD+9AfJ8RG6J4yXreP
	UbQLm7TW1V0/fDelwZ4ai0aJK6VqM80BDHocJMuU=
X-Gm-Gg: ATEYQzyaWMGql5GqGOx56MjmoqWiRpuJEnHIuqnIw+A/bKdqAX6p+rj/Weq87iLod8o
	B6pVXw0q/TjdyxjIWPoS38NeB6gGX1QAkn0BzZjSlRMoN8EqjOsdmzv5eLuj5ehALxOLnAuqFbP
	UhKTLfpSYoO8g/vy208dPUffCMjUD6Sl9qCMn+AXd5JGib4mhnp+B/dEY/DE8+2ffjyIhaX3Ud6
	u45Bd/56auG4V8NTtTEV4fgyhINpegglLsphyP0G4K5uSjTaJUCEhMyjIfrEohECuDJopihZ/+q
	YD92s1+aO1VHKbRTtUKZT9teaYZF3LlYOYg9AMwIsg==
X-Received: by 2002:a05:6820:1898:b0:67b:6ad7:e1cc with SMTP id
 006d021491bc7-67bbc7330ecmr805755eaf.24.1773091251078; Mon, 09 Mar 2026
 14:20:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Tom Ryan <ryan36005@gmail.com>
Date: Mon, 9 Mar 2026 14:20:38 -0700
X-Gm-Features: AaiRm50sXakpAzy2P0x8ehbC5dlD3gPUJX59Zw6P_W36dm8Od2F7CYDtz1xXHns
Message-ID: <CAJuauuPNcDAAzjzVjOE_sNcUT5FX6dwcV9o=hLC6ZaQkkZ72Pg@mail.gmail.com>
Subject: io_uring: OOB read in SQE_MIXED mode via sq_array physical index bypass
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="0000000000002d139b064c9dfaf2"
X-Rspamd-Queue-Id: C418D2418FE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,multipart/alternative,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12606-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~,4:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ryan36005@gmail.com,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

--0000000000002d139b064c9dfaf2
Content-Type: multipart/alternative; boundary="0000000000002d1399064c9dfaf0"

--0000000000002d1399064c9dfaf0
Content-Type: text/plain; charset="UTF-8"

Hi All,

Patch attached.

Thanks,
Tom

--0000000000002d1399064c9dfaf0
Content-Type: text/html; charset="UTF-8"

<div dir="ltr"><div dir="ltr"><div>Hi All,</div><div><br></div><div>Patch attached.</div><br></div><div dir="ltr">Thanks,</div><div dir="ltr">Tom</div><br></div>

--0000000000002d1399064c9dfaf0--
--0000000000002d139b064c9dfaf2
Content-Type: application/octet-stream; 
	name="0001-io_uring-validate-physical-SQE-index-for-SQE_MIXED-128b-ops.patch"
Content-Disposition: attachment; 
	filename="0001-io_uring-validate-physical-SQE-index-for-SQE_MIXED-128b-ops.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mmjoqhqk0>
X-Attachment-Id: f_mmjoqhqk0

RnJvbSA0YmE2N2IwMGQxNzZlOWYwZGRmZjhmYzgwZDVjMjgwNTFkNTgwZjhiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBUb20gUnlhbiA8cnlhbjM2MDA1QGdtYWlsLmNvbT4KRGF0ZTog
TW9uLCA5IE1hciAyMDI2IDA5OjE0OjU5IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gaW9fdXJpbmc6
IHZhbGlkYXRlIHBoeXNpY2FsIFNRRSBpbmRleCBmb3IgU1FFX01JWEVEIDEyOC1ieXRlCiBvcHMK
CldoZW4gSU9SSU5HX1NFVFVQX1NRRV9NSVhFRCBpcyB1c2VkIHdpdGggc3FfYXJyYXkgKHRoZSBk
ZWZhdWx0LCB3aXRob3V0CklPUklOR19TRVRVUF9OT19TUUFSUkFZKSwgdGhlIGJvdW5kYXJ5IGNo
ZWNrIGZvciAxMjgtYnl0ZSBTUUUgb3BlcmF0aW9ucwppbiBpb19pbml0X3JlcSgpIHZhbGlkYXRl
cyB0aGUgbG9naWNhbCBTUSBoZWFkIHBvc2l0aW9uIGJ1dCBub3QgdGhlCnBoeXNpY2FsIGluZGV4
IG9idGFpbmVkIGZyb20gc3FfYXJyYXkuCgpTaW5jZSBzcV9hcnJheSBhbGxvd3MgdXNlci1jb250
cm9sbGVkIHJlbWFwcGluZyBvZiBsb2dpY2FsIHRvIHBoeXNpY2FsClNRRSBpbmRpY2VzLCBhbiB1
bnByaXZpbGVnZWQgdXNlciBjYW4gc2V0IHNxX2FycmF5W05dID0gc3FfZW50cmllcyAtIDEsCnBs
YWNpbmcgYSAxMjgtYnl0ZSBvcGVyYXRpb24gYXQgdGhlIGxhc3QgcGh5c2ljYWwgU1FFIHNsb3Qu
IFRoZQpzdWJzZXF1ZW50IDEyOC1ieXRlIG1lbWNweSBpbiBpb191cmluZ19jbWRfc3FlX2NvcHko
KSB0aGVuIHJlYWRzIDY0CmJ5dGVzIHBhc3QgdGhlIGVuZCBvZiB0aGUgU1FFIGFycmF5LgoKRml4
IHRoaXMgYnkgY2hlY2tpbmcgdGhhdCB0aGUgcGh5c2ljYWwgU1FFIGluZGV4IChkZXJpdmVkIGZy
b20gdGhlIHNxZQpwb2ludGVyKSBoYXMgcm9vbSBmb3IgdGhlIGZ1bGwgMTI4LWJ5dGUgcmVhZCwg
aS5lLiwgaXMgbm90IHRoZSBsYXN0CmVudHJ5IGluIHRoZSBhcnJheS4KCkZpeGVzOiAxY2JhMzBi
ZjlmZGQgKCJpb191cmluZzogYWRkIHN1cHBvcnQgZm9yIElPUklOR19TRVRVUF9TUUVfTUlYRUQi
KQpTaWduZWQtb2ZmLWJ5OiBUb20gUnlhbiA8cnlhbjM2MDA1QGdtYWlsLmNvbT4KLS0tCiBpb191
cmluZy9pb191cmluZy5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykK
CmRpZmYgLS1naXQgYS9pb191cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpp
bmRleCBhYTk1NzAzMTYuLjJmYTcyZDVlNSAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcu
YworKysgYi9pb191cmluZy9pb191cmluZy5jCkBAIC0xNzQ3LDYgKzE3NDcsOSBAQCBzdGF0aWMg
aW50IGlvX2luaXRfcmVxKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBzdHJ1Y3QgaW9fa2lvY2Ig
KnJlcSwKIAkJaWYgKCEoY3R4LT5mbGFncyAmIElPUklOR19TRVRVUF9TUUVfTUlYRUQpIHx8ICps
ZWZ0IDwgMiB8fAogCQkgICAgIShjdHgtPmNhY2hlZF9zcV9oZWFkICYgKGN0eC0+c3FfZW50cmll
cyAtIDEpKSkKIAkJCXJldHVybiBpb19pbml0X2ZhaWxfcmVxKHJlcSwgLUVJTlZBTCk7CisJCS8q
IFZhbGlkYXRlIHBoeXNpY2FsIFNRRSBpbmRleCBoYXMgcm9vbSBmb3IgMTI4LWJ5dGUgcmVhZCAq
LworCQlpZiAoKHVuc2lnbmVkKShzcWUgLSBjdHgtPnNxX3NxZXMpID49IGN0eC0+c3FfZW50cmll
cyAtIDEpCisJCQlyZXR1cm4gaW9faW5pdF9mYWlsX3JlcShyZXEsIC1FSU5WQUwpOwogCQkvKgog
CQkgKiBBIDEyOGIgb3BlcmF0aW9uIG9uIGEgbWl4ZWQgU1EgdXNlcyB0d28gZW50cmllcywgc28g
d2UgaGF2ZQogCQkgKiB0byBpbmNyZW1lbnQgdGhlIGhlYWQgYW5kIGNhY2hlZCByZWZzLCBhbmQg
ZGVjcmVtZW50IHdoYXQncwotLSAKMi41MC4xIChBcHBsZSBHaXQtMTU1KQoK
--0000000000002d139b064c9dfaf2--

