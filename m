Return-Path: <io-uring+bounces-4504-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7D19BF0C0
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:53:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E2EB1C21504
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C9161DFE3A;
	Wed,  6 Nov 2024 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sg3xG73y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE1F185B54
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904806; cv=none; b=P4P9mwS3PLJ3PjCkXY9yaFHpSCkEd5MtB8ivWzWs4C/A1li1vSMqOMvZR84QiyVcnrHjXcJapi/ykb75aBB0mTpvih41QriTRY319ib4eMX5VNTjmXAMGnRgRoO4KPAD1ahn772s7S0TbG7NT04aBJuJmnS4XM+1Br5WmcjAEHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904806; c=relaxed/simple;
	bh=G2jaxQfT2fbSgjgXCYa8KtPcT3+mK6CsSC8rpSsb2H4=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=FFk/wOkCJzYau6B05s7KNN2tdEcDM6fJHs6zWj6z11wUC+17BF4tR1RnFVftc8Y0bgvEhNDOvE+84xjqpfJp+BFHF86uTpwtuf1VYzRQ1EMkO+S396vmyh+K82dDFkBK4mNS+aL6+1Vql9qHNlLhqgeRXDDMt6smQ8YmCtYu/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sg3xG73y; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a6af694220so21525635ab.1
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 06:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730904803; x=1731509603; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Q2eJQUTsEVo6EaqIKMHjMLLMN2rbA0ncoxd0EmhWE8=;
        b=sg3xG73yjaBhEEoFl53sLQHcO7VFIYLVEVnnXn8RhrJuckRT1dnIeEMEC25gH8skS0
         bao9v/NTKsui+4nZnhpMwxQkp1akwt3YSOfuay7tv0EODuJCJX5uBRzjwMhhdZ9wkTLR
         ceSWKMoBb+UNipOwEVBgZXzt6FPIelQq2bziD2edox06Tmoi+5xM7Rw7rJpCYMRQMxMM
         rhEVHvGtExcHvVceLwQTunMCl3UMErYGacwTAzBnfqkzisfDXtowtzzjaLYPeu253uXR
         4nOzbiVJZcr4DhDRtOvR2RcgPNVoPf1yNm0iw5onRQLEzMI5+qZSpQvbrUrL4xLHcnW9
         vI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730904803; x=1731509603;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Q2eJQUTsEVo6EaqIKMHjMLLMN2rbA0ncoxd0EmhWE8=;
        b=mnnWzTukC9fWHnu9bWXy3bPT1ctiVTMNsuIs6o1+2+upwVb83lCzKeeLRlh3hG7ebS
         nVG99QFMSZh1IRoS0/5+H2oujISh/2SuD8TlzaN1dAY1A1Y4bMyhyIDWL5r5s5gwJy3u
         JKSwu3M+glqWeaSSyWTa0G+/X9/k9wpWqsGJxNH7Wxa4FFQtqvpujt3EHlMG+gW2ne5h
         rQ8nT32LZWp7qfrZE+cL73ZX8XNCSuMyN3FVxDCtbJ13FOATFE1Bm3B5A0vear6POlrB
         WozOyALDGmL3QOSxiVp4mseSb9SLawztaPSwhPtVg4C+rB/ugnzkTCGXmlIiqTiAZYpu
         qUSA==
X-Forwarded-Encrypted: i=1; AJvYcCXrRdgoZJPhyktTXWz6pXOhjZf0RmhsQDhWnSTORY5BK3FH5aG8YkVIIy3g8nxBO6EdPnm3yLmRug==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBzeQujMxBEFb6Z5pNZ9qOFiz0/4jGA+rOLGJGtNOr4GwcL9+J
	oVTf8DPVZqtBoh5O2vj+hU4LZIbDX227htLmJ/2IUQQLB1xHEHGxi2EQ6IZ3vR+LlTCo4OV5VSn
	y8/s=
X-Google-Smtp-Source: AGHT+IFOzupSaEbzP2L1VEj+gsGfB+Uu26zJjOquBIZaofIEdss9CxhGOWZ9nq5Sg1hSUz5iru/3eg==
X-Received: by 2002:a92:c24a:0:b0:3a6:ac17:13e5 with SMTP id e9e14a558f8ab-3a6b0316b8cmr212863505ab.11.1730904803164;
        Wed, 06 Nov 2024 06:53:23 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de048e5362sm2955116173.80.2024.11.06.06.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 06:53:22 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------SnDMCXBzrXGWHoqDx5Ak092X"
Message-ID: <ce4e199e-5559-4b46-ae81-195d321b708a@kernel.dk>
Date: Wed, 6 Nov 2024 07:53:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/rw: fix missing NOWAIT check for O_DIRECT
 start write" failed to apply to v5.10-stable tree
To: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Peter Mann <peter.mann@sh.cz>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241106021306.183371-1-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241106021306.183371-1-sashal@kernel.org>

This is a multi-part message in MIME format.
--------------SnDMCXBzrXGWHoqDx5Ak092X
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/24 7:13 PM, Sasha Levin wrote:
> The patch below does not apply to the v5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the 5.10-stable series.

-- 
Jens Axboe

--------------SnDMCXBzrXGWHoqDx5Ak092X
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io_uring-rw-fix-missing-NOWAIT-check-for-O_DIRECT-st.patch"
Content-Disposition: attachment;
 filename*0="0004-io_uring-rw-fix-missing-NOWAIT-check-for-O_DIRECT-st.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA1MWY3M2ZlMGFjMzI5NTVlMTRiODJkZGMwOWFmOTdhNGY0YTUwMGUwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMzEgT2N0IDIwMjQgMDg6MDU6NDQgLTA2MDAKU3ViamVjdDogW1BBVENIIDQv
NF0gaW9fdXJpbmcvcnc6IGZpeCBtaXNzaW5nIE5PV0FJVCBjaGVjayBmb3IgT19ESVJFQ1Qg
c3RhcnQKIHdyaXRlCgpDb21taXQgMWQ2MGQ3NGU4NTI2NDcyNTViZDhlNzZmNWEyMmRjNDI1
MzFlNDM4OSB1cHN0cmVhbS4KCldoZW4gaW9fdXJpbmcgc3RhcnRzIGEgd3JpdGUsIGl0J2xs
IGNhbGwga2lvY2Jfc3RhcnRfd3JpdGUoKSB0byBidW1wIHRoZQpzdXBlciBibG9jayByd3Nl
bSwgcHJldmVudGluZyBhbnkgZnJlZXplcyBmcm9tIGhhcHBlbmluZyB3aGlsZSB0aGF0Cndy
aXRlIGlzIGluLWZsaWdodC4gVGhlIGZyZWV6ZSBzaWRlIHdpbGwgZ3JhYiB0aGF0IHJ3c2Vt
IGZvciB3cml0aW5nLApleGNsdWRpbmcgYW55IG5ldyB3cml0ZXJzIGZyb20gaGFwcGVuaW5n
IGFuZCB3YWl0aW5nIGZvciBleGlzdGluZyB3cml0ZXMKdG8gZmluaXNoLiBCdXQgaW9fdXJp
bmcgdW5jb25kaXRpb25hbGx5IHVzZXMga2lvY2Jfc3RhcnRfd3JpdGUoKSwgd2hpY2gKd2ls
bCBibG9jayBpZiBzb21lb25lIGlzIGN1cnJlbnRseSBhdHRlbXB0aW5nIHRvIGZyZWV6ZSB0
aGUgbW91bnQgcG9pbnQuClRoaXMgY2F1c2VzIGEgZGVhZGxvY2sgd2hlcmUgZnJlZXplIGlz
IHdhaXRpbmcgZm9yIHByZXZpb3VzIHdyaXRlcyB0bwpjb21wbGV0ZSwgYnV0IHRoZSBwcmV2
aW91cyB3cml0ZXMgY2Fubm90IGNvbXBsZXRlLCBhcyB0aGUgdGFzayB0aGF0IGlzCnN1cHBv
c2VkIHRvIGNvbXBsZXRlIHRoZW0gaXMgYmxvY2tlZCB3YWl0aW5nIG9uIHN0YXJ0aW5nIGEg
bmV3IHdyaXRlLgpUaGlzIHJlc3VsdHMgaW4gdGhlIGZvbGxvd2luZyBzdHVjayB0cmFjZSBz
aG93aW5nIHRoYXQgZGVwZW5kZW5jeSB3aXRoCnRoZSB3cml0ZSBibG9ja2VkIHN0YXJ0aW5n
IGEgbmV3IHdyaXRlOgoKdGFzazpmaW8gICAgICAgICAgICAgc3RhdGU6RCBzdGFjazowICAg
ICBwaWQ6ODg2ICAgdGdpZDo4ODYgICBwcGlkOjg3NgpDYWxsIHRyYWNlOgogX19zd2l0Y2hf
dG8rMHgxZDgvMHgzNDgKIF9fc2NoZWR1bGUrMHg4ZTgvMHgyMjQ4CiBzY2hlZHVsZSsweDEx
MC8weDNmMAogcGVyY3B1X3J3c2VtX3dhaXQrMHgxZTgvMHgzZjgKIF9fcGVyY3B1X2Rvd25f
cmVhZCsweGU4LzB4NTAwCiBpb193cml0ZSsweGJiOC8weGZmOAogaW9faXNzdWVfc3FlKzB4
MTBjLzB4MTAyMAogaW9fc3VibWl0X3NxZXMrMHg2MTQvMHgyMTEwCiBfX2FybTY0X3N5c19p
b191cmluZ19lbnRlcisweDUyNC8weDEwMzgKIGludm9rZV9zeXNjYWxsKzB4NzQvMHgyNjgK
IGVsMF9zdmNfY29tbW9uLmNvbnN0cHJvcC4wKzB4MTYwLzB4MjM4CiBkb19lbDBfc3ZjKzB4
NDQvMHg2MAogZWwwX3N2YysweDQ0LzB4YjAKIGVsMHRfNjRfc3luY19oYW5kbGVyKzB4MTE4
LzB4MTI4CiBlbDB0XzY0X3N5bmMrMHgxNjgvMHgxNzAKSU5GTzogdGFzayBmc2ZyZWV6ZTo3
MzY0IGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxNSBzZWNvbmRzLgogICAgICBOb3QgdGFpbnRl
ZCA2LjEyLjAtcmM1LTAwMDYzLWc3NmFhZjk0NTcwMWMgIzc5NjMKCndpdGggdGhlIGF0dGVt
cHRpbmcgZnJlZXplciBzdHVjayB0cnlpbmcgdG8gZ3JhYiB0aGUgcndzZW06Cgp0YXNrOmZz
ZnJlZXplICAgICAgICBzdGF0ZTpEIHN0YWNrOjAgICAgIHBpZDo3MzY0ICB0Z2lkOjczNjQg
IHBwaWQ6OTk1CkNhbGwgdHJhY2U6CiBfX3N3aXRjaF90bysweDFkOC8weDM0OAogX19zY2hl
ZHVsZSsweDhlOC8weDIyNDgKIHNjaGVkdWxlKzB4MTEwLzB4M2YwCiBwZXJjcHVfZG93bl93
cml0ZSsweDJiMC8weDY4MAogZnJlZXplX3N1cGVyKzB4MjQ4LzB4OGE4CiBkb192ZnNfaW9j
dGwrMHgxNDljLzB4MWIxOAogX19hcm02NF9zeXNfaW9jdGwrMHhkMC8weDFhMAogaW52b2tl
X3N5c2NhbGwrMHg3NC8weDI2OAogZWwwX3N2Y19jb21tb24uY29uc3Rwcm9wLjArMHgxNjAv
MHgyMzgKIGRvX2VsMF9zdmMrMHg0NC8weDYwCiBlbDBfc3ZjKzB4NDQvMHhiMAogZWwwdF82
NF9zeW5jX2hhbmRsZXIrMHgxMTgvMHgxMjgKIGVsMHRfNjRfc3luYysweDE2OC8weDE3MAoK
Rml4IHRoaXMgYnkgaGF2aW5nIHRoZSBpb191cmluZyBzaWRlIGhvbm9yIElPQ0JfTk9XQUlU
LCBhbmQgb25seSBhdHRlbXB0IGEKYmxvY2tpbmcgZ3JhYiBvZiB0aGUgc3VwZXIgYmxvY2sg
cndzZW0gaWYgaXQgaXNuJ3Qgc2V0LiBGb3Igbm9ybWFsIGlzc3VlCndoZXJlIElPQ0JfTk9X
QUlUIHdvdWxkIGFsd2F5cyBiZSBzZXQsIHRoaXMgcmV0dXJucyAtRUFHQUlOIHdoaWNoIHdp
bGwKaGF2ZSBpb191cmluZyBjb3JlIGlzc3VlIGEgYmxvY2tpbmcgYXR0ZW1wdCBvZiB0aGUg
d3JpdGUuIFRoYXQgd2lsbCBpbgp0dXJuIGFsc28gZ2V0IGNvbXBsZXRpb25zIHJ1biwgZW5z
dXJpbmcgZm9yd2FyZCBwcm9ncmVzcy4KClNpbmNlIGZyZWV6aW5nIHJlcXVpcmVzIENBUF9T
WVNfQURNSU4gaW4gdGhlIGZpcnN0IHBsYWNlLCB0aGlzIGlzbid0CnNvbWV0aGluZyB0aGF0
IGNhbiBiZSB0cmlnZ2VyZWQgYnkgYSByZWd1bGFyIHVzZXIuCgpDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZyAjIDUuMTArClJlcG9ydGVkLWJ5OiBQZXRlciBNYW5uIDxwZXRlci5tYW5u
QHNoLmN6PgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9pby11cmluZy8zOGM5NGFl
Yy04MWM5LTRmNjItYjQ0ZS0xZDg3ZjU1OTc2NDRAc2guY3oKU2lnbmVkLW9mZi1ieTogSmVu
cyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGlvX3VyaW5nL2lvX3VyaW5nLmMgfCAy
MyArKysrKysrKysrKysrKysrKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcu
YyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggYTZhZmRlYTVjZmQ4Li41N2M1MWU5NjM4
NzUgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5nLmMKKysrIGIvaW9fdXJpbmcvaW9f
dXJpbmcuYwpAQCAtMzcxOSw2ICszNzE5LDI1IEBAIHN0YXRpYyBpbnQgaW9fd3JpdGVfcHJl
cChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgY29uc3Qgc3RydWN0IGlvX3VyaW5nX3NxZSAqc3Fl
KQogCXJldHVybiBpb19wcmVwX3J3KHJlcSwgc3FlLCBXUklURSk7CiB9CiAKK3N0YXRpYyBi
b29sIGlvX2tpb2NiX3N0YXJ0X3dyaXRlKHN0cnVjdCBpb19raW9jYiAqcmVxLCBzdHJ1Y3Qg
a2lvY2IgKmtpb2NiKQoreworCXN0cnVjdCBpbm9kZSAqaW5vZGU7CisJYm9vbCByZXQ7CisK
KwlpZiAoIShyZXEtPmZsYWdzICYgUkVRX0ZfSVNSRUcpKQorCQlyZXR1cm4gdHJ1ZTsKKwlp
ZiAoIShraW9jYi0+a2lfZmxhZ3MgJiBJT0NCX05PV0FJVCkpIHsKKwkJa2lvY2Jfc3RhcnRf
d3JpdGUoa2lvY2IpOworCQlyZXR1cm4gdHJ1ZTsKKwl9CisKKwlpbm9kZSA9IGZpbGVfaW5v
ZGUoa2lvY2ItPmtpX2ZpbHApOworCXJldCA9IHNiX3N0YXJ0X3dyaXRlX3RyeWxvY2soaW5v
ZGUtPmlfc2IpOworCWlmIChyZXQpCisJCV9fc2Jfd3JpdGVyc19yZWxlYXNlKGlub2RlLT5p
X3NiLCBTQl9GUkVFWkVfV1JJVEUpOworCXJldHVybiByZXQ7Cit9CisKIHN0YXRpYyBpbnQg
aW9fd3JpdGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFn
cykKIHsKIAlzdHJ1Y3QgaW92ZWMgaW5saW5lX3ZlY3NbVUlPX0ZBU1RJT1ZdLCAqaW92ZWMg
PSBpbmxpbmVfdmVjczsKQEAgLTM3NjUsOCArMzc4NCw4IEBAIHN0YXRpYyBpbnQgaW9fd3Jp
dGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykKIAlp
ZiAodW5saWtlbHkocmV0KSkKIAkJZ290byBvdXRfZnJlZTsKIAotCWlmIChyZXEtPmZsYWdz
ICYgUkVRX0ZfSVNSRUcpCi0JCWtpb2NiX3N0YXJ0X3dyaXRlKGtpb2NiKTsKKwlpZiAodW5s
aWtlbHkoIWlvX2tpb2NiX3N0YXJ0X3dyaXRlKHJlcSwga2lvY2IpKSkKKwkJZ290byBjb3B5
X2lvdjsKIAlraW9jYi0+a2lfZmxhZ3MgfD0gSU9DQl9XUklURTsKIAogCWlmIChyZXEtPmZp
bGUtPmZfb3AtPndyaXRlX2l0ZXIpCi0tIAoyLjQ1LjIKCg==
--------------SnDMCXBzrXGWHoqDx5Ak092X
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-use-kiocb_-start-end-_write-helpers.patch"
Content-Disposition: attachment;
 filename="0003-io_uring-use-kiocb_-start-end-_write-helpers.patch"
Content-Transfer-Encoding: base64

RnJvbSA3Y2E2YjNiYTg5YjU0MTlhZDYxYWU2NjRmZDMxOWM5NmU4MWNkNThlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwu
Y29tPgpEYXRlOiBUaHUsIDE3IEF1ZyAyMDIzIDE3OjEzOjM0ICswMzAwClN1YmplY3Q6IFtQ
QVRDSCAzLzRdIGlvX3VyaW5nOiB1c2Uga2lvY2Jfe3N0YXJ0LGVuZH1fd3JpdGUoKSBoZWxw
ZXJzCgpDb21taXQgZTQ4NGZkNzNmNGJkY2IwMGMyMTg4MTAwYzJkODRlOWYzZjVjOWY3ZCB1
cHN0cmVhbS4KClVzZSBoZWxwZXJzIGluc3RlYWQgb2YgdGhlIG9wZW4gY29kZWQgZGFuY2Ug
dG8gc2lsZW5jZSBsb2NrZGVwIHdhcm5pbmdzLgoKU3VnZ2VzdGVkLWJ5OiBKYW4gS2FyYSA8
amFja0BzdXNlLmN6PgpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxA
Z21haWwuY29tPgpSZXZpZXdlZC1ieTogSmFuIEthcmEgPGphY2tAc3VzZS5jej4KUmV2aWV3
ZWQtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KTWVzc2FnZS1JZDogPDIwMjMw
ODE3MTQxMzM3LjEwMjU4OTEtNS1hbWlyNzNpbEBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6
IENocmlzdGlhbiBCcmF1bmVyIDxicmF1bmVyQGtlcm5lbC5vcmc+Ci0tLQogaW9fdXJpbmcv
aW9fdXJpbmcuYyB8IDIzICsrKystLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191
cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwppbmRleCBlYzU1ZjI3ODhh
YzYuLmE2YWZkZWE1Y2ZkOCAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysg
Yi9pb191cmluZy9pb191cmluZy5jCkBAIC0yNjY5LDE1ICsyNjY5LDEwIEBAIHN0YXRpYyBp
bnQgaW9faW9wb2xsX2NoZWNrKHN0cnVjdCBpb19yaW5nX2N0eCAqY3R4LCBsb25nIG1pbikK
IAogc3RhdGljIHZvaWQgaW9fcmVxX2VuZF93cml0ZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSkK
IHsKLQkvKgotCSAqIFRlbGwgbG9ja2RlcCB3ZSBpbmhlcml0ZWQgZnJlZXplIHByb3RlY3Rp
b24gZnJvbSBzdWJtaXNzaW9uCi0JICogdGhyZWFkLgotCSAqLwogCWlmIChyZXEtPmZsYWdz
ICYgUkVRX0ZfSVNSRUcpIHsKLQkJc3RydWN0IHN1cGVyX2Jsb2NrICpzYiA9IGZpbGVfaW5v
ZGUocmVxLT5maWxlKS0+aV9zYjsKKwkJc3RydWN0IGlvX3J3ICpydyA9ICZyZXEtPnJ3Owog
Ci0JCV9fc2Jfd3JpdGVyc19hY3F1aXJlZChzYiwgU0JfRlJFRVpFX1dSSVRFKTsKLQkJc2Jf
ZW5kX3dyaXRlKHNiKTsKKwkJa2lvY2JfZW5kX3dyaXRlKCZydy0+a2lvY2IpOwogCX0KIH0K
IApAQCAtMzc3MCwxOCArMzc2NSw4IEBAIHN0YXRpYyBpbnQgaW9fd3JpdGUoc3RydWN0IGlv
X2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFncykKIAlpZiAodW5saWtlbHko
cmV0KSkKIAkJZ290byBvdXRfZnJlZTsKIAotCS8qCi0JICogT3Blbi1jb2RlIGZpbGVfc3Rh
cnRfd3JpdGUgaGVyZSB0byBncmFiIGZyZWV6ZSBwcm90ZWN0aW9uLAotCSAqIHdoaWNoIHdp
bGwgYmUgcmVsZWFzZWQgYnkgYW5vdGhlciB0aHJlYWQgaW4KLQkgKiBpb19jb21wbGV0ZV9y
dygpLiAgRm9vbCBsb2NrZGVwIGJ5IHRlbGxpbmcgaXQgdGhlIGxvY2sgZ290Ci0JICogcmVs
ZWFzZWQgc28gdGhhdCBpdCBkb2Vzbid0IGNvbXBsYWluIGFib3V0IHRoZSBoZWxkIGxvY2sg
d2hlbgotCSAqIHdlIHJldHVybiB0byB1c2Vyc3BhY2UuCi0JICovCi0JaWYgKHJlcS0+Zmxh
Z3MgJiBSRVFfRl9JU1JFRykgewotCQlzYl9zdGFydF93cml0ZShmaWxlX2lub2RlKHJlcS0+
ZmlsZSktPmlfc2IpOwotCQlfX3NiX3dyaXRlcnNfcmVsZWFzZShmaWxlX2lub2RlKHJlcS0+
ZmlsZSktPmlfc2IsCi0JCQkJCVNCX0ZSRUVaRV9XUklURSk7Ci0JfQorCWlmIChyZXEtPmZs
YWdzICYgUkVRX0ZfSVNSRUcpCisJCWtpb2NiX3N0YXJ0X3dyaXRlKGtpb2NiKTsKIAlraW9j
Yi0+a2lfZmxhZ3MgfD0gSU9DQl9XUklURTsKIAogCWlmIChyZXEtPmZpbGUtPmZfb3AtPndy
aXRlX2l0ZXIpCi0tIAoyLjQ1LjIKCg==
--------------SnDMCXBzrXGWHoqDx5Ak092X
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-fs-create-kiocb_-start-end-_write-helpers.patch"
Content-Disposition: attachment;
 filename="0002-fs-create-kiocb_-start-end-_write-helpers.patch"
Content-Transfer-Encoding: base64

RnJvbSAyOGY4NTViMmUzNGZmMzg1MTY0OTM2MTJjNzRiYzAyZGVmNGNmZGRhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwu
Y29tPgpEYXRlOiBUaHUsIDE3IEF1ZyAyMDIzIDE3OjEzOjMzICswMzAwClN1YmplY3Q6IFtQ
QVRDSCAyLzRdIGZzOiBjcmVhdGUga2lvY2Jfe3N0YXJ0LGVuZH1fd3JpdGUoKSBoZWxwZXJz
CgpDb21taXQgZWQwMzYwYmJhYjcyYjgyOTQzN2I2N2ViYjJmOWNmYWMxOWY1OWRmZSB1cHN0
cmVhbS4KCmFpbywgaW9fdXJpbmcsIGNhY2hlZmlsZXMgYW5kIG92ZXJsYXlmcywgYWxsIG9w
ZW4gY29kZSBhbiB1Z2x5IHZhcmlhbnQKb2YgZmlsZV97c3RhcnQsZW5kfV93cml0ZSgpIHRv
IHNpbGVuY2UgbG9ja2RlcCB3YXJuaW5ncy4KCkNyZWF0ZSBoZWxwZXJzIGZvciB0aGlzIGxv
Y2tkZXAgZGFuY2Ugc28gd2UgY2FuIHVzZSB0aGUgaGVscGVycyBpbiBhbGwKdGhlIGNhbGxl
cnMuCgpTdWdnZXN0ZWQtYnk6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+ClNpZ25lZC1vZmYt
Ynk6IEFtaXIgR29sZHN0ZWluIDxhbWlyNzNpbEBnbWFpbC5jb20+ClJldmlld2VkLWJ5OiBK
YW4gS2FyYSA8amFja0BzdXNlLmN6PgpSZXZpZXdlZC1ieTogSmVucyBBeGJvZSA8YXhib2VA
a2VybmVsLmRrPgpNZXNzYWdlLUlkOiA8MjAyMzA4MTcxNDEzMzcuMTAyNTg5MS00LWFtaXI3
M2lsQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogQ2hyaXN0aWFuIEJyYXVuZXIgPGJyYXVu
ZXJAa2VybmVsLm9yZz4KLS0tCiBpbmNsdWRlL2xpbnV4L2ZzLmggfCAzNSArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDM1IGluc2VydGlv
bnMoKykKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ZzLmggYi9pbmNsdWRlL2xpbnV4
L2ZzLmgKaW5kZXggYTdkODM5YjE5NjA2Li40ZTQ3NWRlZDVjZjUgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbGludXgvZnMuaAorKysgYi9pbmNsdWRlL2xpbnV4L2ZzLmgKQEAgLTE3OTcsNiAr
MTc5Nyw0MSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgc2Jfc3RhcnRfaW50d3JpdGVfdHJ5bG9j
ayhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCXJldHVybiBfX3NiX3N0YXJ0X3dyaXRlX3Ry
eWxvY2soc2IsIFNCX0ZSRUVaRV9GUyk7CiB9CiAKKy8qKgorICoga2lvY2Jfc3RhcnRfd3Jp
dGUgLSBnZXQgd3JpdGUgYWNjZXNzIHRvIGEgc3VwZXJibG9jayBmb3IgYXN5bmMgZmlsZSBp
bworICogQGlvY2I6IHRoZSBpbyBjb250ZXh0IHdlIHdhbnQgdG8gc3VibWl0IHRoZSB3cml0
ZSB3aXRoCisgKgorICogVGhpcyBpcyBhIHZhcmlhbnQgb2Ygc2Jfc3RhcnRfd3JpdGUoKSBm
b3IgYXN5bmMgaW8gc3VibWlzc2lvbi4KKyAqIFNob3VsZCBiZSBtYXRjaGVkIHdpdGggYSBj
YWxsIHRvIGtpb2NiX2VuZF93cml0ZSgpLgorICovCitzdGF0aWMgaW5saW5lIHZvaWQga2lv
Y2Jfc3RhcnRfd3JpdGUoc3RydWN0IGtpb2NiICppb2NiKQoreworCXN0cnVjdCBpbm9kZSAq
aW5vZGUgPSBmaWxlX2lub2RlKGlvY2ItPmtpX2ZpbHApOworCisJc2Jfc3RhcnRfd3JpdGUo
aW5vZGUtPmlfc2IpOworCS8qCisJICogRm9vbCBsb2NrZGVwIGJ5IHRlbGxpbmcgaXQgdGhl
IGxvY2sgZ290IHJlbGVhc2VkIHNvIHRoYXQgaXQKKwkgKiBkb2Vzbid0IGNvbXBsYWluIGFi
b3V0IHRoZSBoZWxkIGxvY2sgd2hlbiB3ZSByZXR1cm4gdG8gdXNlcnNwYWNlLgorCSAqLwor
CV9fc2Jfd3JpdGVyc19yZWxlYXNlKGlub2RlLT5pX3NiLCBTQl9GUkVFWkVfV1JJVEUpOwor
fQorCisvKioKKyAqIGtpb2NiX2VuZF93cml0ZSAtIGRyb3Agd3JpdGUgYWNjZXNzIHRvIGEg
c3VwZXJibG9jayBhZnRlciBhc3luYyBmaWxlIGlvCisgKiBAaW9jYjogdGhlIGlvIGNvbnRl
eHQgd2Ugc3VtYml0dGVkIHRoZSB3cml0ZSB3aXRoCisgKgorICogU2hvdWxkIGJlIG1hdGNo
ZWQgd2l0aCBhIGNhbGwgdG8ga2lvY2Jfc3RhcnRfd3JpdGUoKS4KKyAqLworc3RhdGljIGlu
bGluZSB2b2lkIGtpb2NiX2VuZF93cml0ZShzdHJ1Y3Qga2lvY2IgKmlvY2IpCit7CisJc3Ry
dWN0IGlub2RlICppbm9kZSA9IGZpbGVfaW5vZGUoaW9jYi0+a2lfZmlscCk7CisKKwkvKgor
CSAqIFRlbGwgbG9ja2RlcCB3ZSBpbmhlcml0ZWQgZnJlZXplIHByb3RlY3Rpb24gZnJvbSBz
dWJtaXNzaW9uIHRocmVhZC4KKwkgKi8KKwlfX3NiX3dyaXRlcnNfYWNxdWlyZWQoaW5vZGUt
Pmlfc2IsIFNCX0ZSRUVaRV9XUklURSk7CisJc2JfZW5kX3dyaXRlKGlub2RlLT5pX3NiKTsK
K30KIAogZXh0ZXJuIGJvb2wgaW5vZGVfb3duZXJfb3JfY2FwYWJsZShjb25zdCBzdHJ1Y3Qg
aW5vZGUgKmlub2RlKTsKIAotLSAKMi40NS4yCgo=
--------------SnDMCXBzrXGWHoqDx5Ak092X
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-rename-kiocb_end_write-local-helper.patch"
Content-Disposition: attachment;
 filename="0001-io_uring-rename-kiocb_end_write-local-helper.patch"
Content-Transfer-Encoding: base64

RnJvbSAxMzcyODcwNGEwYWE1OTA1MTUzNjMyN2U1ODQ2OTI2OTIwMWRkNzliIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwu
Y29tPgpEYXRlOiBUaHUsIDE3IEF1ZyAyMDIzIDE3OjEzOjMxICswMzAwClN1YmplY3Q6IFtQ
QVRDSCAxLzRdIGlvX3VyaW5nOiByZW5hbWUga2lvY2JfZW5kX3dyaXRlKCkgbG9jYWwgaGVs
cGVyCgpDb21taXQgYTM3MDE2N2ZlNTI2MTIzNjM3OTY1ZjYwODU5YTlmMWYzZTFhNThiNyB1
cHN0cmVhbS4KClRoaXMgaGVscGVyIGRvZXMgbm90IHRha2UgYSBraW9jYiBhcyBpbnB1dCBh
bmQgd2Ugd2FudCB0byBjcmVhdGUgYQpjb21tb24gaGVscGVyIGJ5IHRoYXQgbmFtZSB0aGF0
IHRha2VzIGEga2lvY2IgYXMgaW5wdXQuCgpTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVp
biA8YW1pcjczaWxAZ21haWwuY29tPgpSZXZpZXdlZC1ieTogSmFuIEthcmEgPGphY2tAc3Vz
ZS5jej4KUmV2aWV3ZWQtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4KTWVzc2Fn
ZS1JZDogPDIwMjMwODE3MTQxMzM3LjEwMjU4OTEtMi1hbWlyNzNpbEBnbWFpbC5jb20+ClNp
Z25lZC1vZmYtYnk6IENocmlzdGlhbiBCcmF1bmVyIDxicmF1bmVyQGtlcm5lbC5vcmc+Ci0t
LQogaW9fdXJpbmcvaW9fdXJpbmcuYyB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW9fdXJpbmcv
aW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggZGEwN2ZiYTc1ODI3Li5l
YzU1ZjI3ODhhYzYgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5nLmMKKysrIGIvaW9f
dXJpbmcvaW9fdXJpbmcuYwpAQCAtMjY2Nyw3ICsyNjY3LDcgQEAgc3RhdGljIGludCBpb19p
b3BvbGxfY2hlY2soc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIGxvbmcgbWluKQogCXJldHVy
biByZXQ7CiB9CiAKLXN0YXRpYyB2b2lkIGtpb2NiX2VuZF93cml0ZShzdHJ1Y3QgaW9fa2lv
Y2IgKnJlcSkKK3N0YXRpYyB2b2lkIGlvX3JlcV9lbmRfd3JpdGUoc3RydWN0IGlvX2tpb2Ni
ICpyZXEpCiB7CiAJLyoKIAkgKiBUZWxsIGxvY2tkZXAgd2UgaW5oZXJpdGVkIGZyZWV6ZSBw
cm90ZWN0aW9uIGZyb20gc3VibWlzc2lvbgpAQCAtMjczNyw3ICsyNzM3LDcgQEAgc3RhdGlj
IHZvaWQgaW9fcmVxX2lvX2VuZChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSkKIAlzdHJ1Y3QgaW9f
cncgKnJ3ID0gJnJlcS0+cnc7CiAKIAlpZiAocnctPmtpb2NiLmtpX2ZsYWdzICYgSU9DQl9X
UklURSkgewotCQlraW9jYl9lbmRfd3JpdGUocmVxKTsKKwkJaW9fcmVxX2VuZF93cml0ZShy
ZXEpOwogCQlmc25vdGlmeV9tb2RpZnkocmVxLT5maWxlKTsKIAl9IGVsc2UgewogCQlmc25v
dGlmeV9hY2Nlc3MocmVxLT5maWxlKTsKQEAgLTI4MTcsNyArMjgxNyw3IEBAIHN0YXRpYyB2
b2lkIGlvX2NvbXBsZXRlX3J3X2lvcG9sbChzdHJ1Y3Qga2lvY2IgKmtpb2NiLCBsb25nIHJl
cywgbG9uZyByZXMyKQogCXN0cnVjdCBpb19raW9jYiAqcmVxID0gY29udGFpbmVyX29mKGtp
b2NiLCBzdHJ1Y3QgaW9fa2lvY2IsIHJ3Lmtpb2NiKTsKIAogCWlmIChraW9jYi0+a2lfZmxh
Z3MgJiBJT0NCX1dSSVRFKQotCQlraW9jYl9lbmRfd3JpdGUocmVxKTsKKwkJaW9fcmVxX2Vu
ZF93cml0ZShyZXEpOwogCWlmICh1bmxpa2VseShyZXMgIT0gcmVxLT5yZXN1bHQpKSB7CiAJ
CWlmIChyZXMgPT0gLUVBR0FJTiAmJiBpb19yd19zaG91bGRfcmVpc3N1ZShyZXEpKSB7CiAJ
CQlyZXEtPmZsYWdzIHw9IFJFUV9GX1JFSVNTVUU7CkBAIC0zODE3LDcgKzM4MTcsNyBAQCBz
dGF0aWMgaW50IGlvX3dyaXRlKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQg
aXNzdWVfZmxhZ3MpCiAJCXJldCA9IGlvX3NldHVwX2FzeW5jX3J3KHJlcSwgaW92ZWMsIGlu
bGluZV92ZWNzLCBpdGVyLCBmYWxzZSk7CiAJCWlmICghcmV0KSB7CiAJCQlpZiAoa2lvY2It
PmtpX2ZsYWdzICYgSU9DQl9XUklURSkKLQkJCQlraW9jYl9lbmRfd3JpdGUocmVxKTsKKwkJ
CQlpb19yZXFfZW5kX3dyaXRlKHJlcSk7CiAJCQlyZXR1cm4gLUVBR0FJTjsKIAkJfQogCQly
ZXR1cm4gcmV0OwotLSAKMi40NS4yCgo=

--------------SnDMCXBzrXGWHoqDx5Ak092X--

