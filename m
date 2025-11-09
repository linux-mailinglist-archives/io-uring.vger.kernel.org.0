Return-Path: <io-uring+bounces-10482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92432C448EB
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:18:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3715B18848F8
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2F823C4E9;
	Sun,  9 Nov 2025 22:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OnYOTNog"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBC223D28B
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762726708; cv=none; b=WfD3cAUb5IlAcERQPcVgoBCsRzd7SEKrGaBXdeSMkGUT31STqBu6mahv19AsErcjb44YLsggkfaFMahHwWT5051kKsaoh9F+Rdn78m/oXKK8dpKCkI21grdtu8BFN4rVNObHk5/hLfek37VaJIlCFubiIi/DlLDRgxstf6Do0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762726708; c=relaxed/simple;
	bh=HEaCKkagI7xEGXvhFvWM8gI7ljv6HxAqkDDLV3CZn4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ROqf9GtVwOgck29wd2C98GIsnhgsqEKv6X7hj0vLVoooL+8oPVB/CqlAVGdG4n0mOPIY2z/rDsO9VYepkfC3ffD3TEQmhl/kEW3KRHICijajlqqW4VT/18GGB7H6dG13aWPuBeI2dvGJDwVgb0cJJ727Kwog79HYd1xUHperi1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OnYOTNog; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso1664614a12.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762726704; x=1763331504; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TevfzHaLevIRjHijZbrBn/l6LT3zlV1H4/N3hT4FBJw=;
        b=OnYOTNogn132nAD+VTcGPuYWvZ1BtRbUvjyAzqF3nKG5nal7aPJE8U15FjZMw1zq/J
         K8/sXMXY1sBeI1RgavwlVTgZf9O6BnJh3JeuCnJ55UbLLu/St83hdNTbkNluRwAThxKr
         hDv+BVL/O4O/TfSQaMt2AEDOWwhGSZi3Uw+Yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762726704; x=1763331504;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TevfzHaLevIRjHijZbrBn/l6LT3zlV1H4/N3hT4FBJw=;
        b=rhDr7qU+pqsLUuB4dCtoBtlZlEj4WlFyyggTVBLm+SUrWKLain3es3dcInUCntjFvV
         adycNm9k1D/C5o3Jf9CAf8ZflgUlt25CoT88oenwAgleUEEzfCyvFklvQ83yRLmoXYln
         w3UixnzMyn1zsbwK7BxHWxTvf+lzib2x1FclZcE1Kh9ZdNnaJqZDR6zeYYnXtWO+kKV+
         hQMkqHsDK4kRS9ebhCa8Yxv1zOKM57A+wlHEGN4ISMijHz8L80kpqkYiU6NfAjiUArfY
         9aty57nv8Bh8lXOVjwPjYo+6NxBu3N/k+sph0NrWT6E7SjnxyPZxp1lJpbg/HCGHtIU9
         XaqA==
X-Forwarded-Encrypted: i=1; AJvYcCXtCjxJK+wo80TEHWKne6/7FBO7/0Cy1Kktx6FLVJR8cVHiu6AyATCVt6jsPYrKIeyi7Ml/WB0pyw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdk3Sp5GQhINrLEp+n1XY/OArMXmwDobv+5AQzCjFGBBnGpDR8
	SMrFqF6x7ZfGPS+jfqxcMVIXOSQtjSKR9ZzVZ3q6rf6vXc/Gsk+gx6XX2jaKcT/pY3+odSCkZHy
	X99BDpVo=
X-Gm-Gg: ASbGncv+kQ1cvW/JKKSs8z0mGJd5vAgdRTI/8rIB4WH1FOs8j2SVXuiOCU7qzIuPMwe
	XtQM/j+pSXqF40uCOd1f857QfMorn+YWVGbDB0pSlaREH0ZDCJNV94tFV9qLFnzEBZNxRKfvJuJ
	2UiwfgSYnBg6dX9xNRgy4v4X6uePC5Lbaj3KjWCWQUk94ZolguLxd048ydgkqnOCmQ/hc/9Dvmj
	578aoBITw2S1nNiVJEJNmPGeqM1KuY/LEOAnmmSb5cM9spG8dFGMKtj9c+DLscuRvvfGmwBrCWu
	OCt5AZsgq9OCNXsRYdKMCQZPkKZURBG/vsVDRjpA1BeBPXIEnrprMxNhiEj9ssrMnVRr4suzZLu
	qh36MIVLj3kZuwNNYRcnOplOj3B1GGb4Ks+CyPc1m27M5aOHJQpZ4JAU/AZTpXXYUPP6AwJsfNk
	1lwGuXBcxSC1lcr3EBH++nDVb3Eb9i7zfGhTWJ1w75+uvykJIgjlyDzdTtFTCe
X-Google-Smtp-Source: AGHT+IHEUN8tLrO5zEkTDpv2ndR24trmw2Si0UvP5d4A+JCZ7xGvt0l5PRDG4m8qLi0WpbRlw8nbTA==
X-Received: by 2002:a05:6402:4401:b0:640:ef03:82de with SMTP id 4fb4d7f45d1cf-64159b5b5a2mr5017529a12.4.1762726703572;
        Sun, 09 Nov 2025 14:18:23 -0800 (PST)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f813eb6sm9797636a12.14.2025.11.09.14.18.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 14:18:22 -0800 (PST)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b729f239b39so514950966b.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:18:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVf/WV7BakzLg1dydl6POB4RSsrozFTMLCJmTq9A6/5PzBf6FvBMmToKRKAo+J2yLuHXuGW9E7Ppg==@vger.kernel.org
X-Received: by 2002:a17:907:3f25:b0:b72:7e7c:e848 with SMTP id
 a640c23a62f3a-b72d0ad10d8mr820608666b.17.1762726701561; Sun, 09 Nov 2025
 14:18:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
In-Reply-To: <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Nov 2025 14:18:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
X-Gm-Features: AWmQ_bnxiUOgQvp0HIufVmMeT1k19Jn6_9-S50QGPHzn8dX_6-Wb64JFzZ0MAzU
Message-ID: <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e22177064330cab3"

--000000000000e22177064330cab3
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 11:18, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm? Comments?

Oh, and while double-checking bad users, I note that ntfs3 does

        uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
...
        kmem_cache_free(names_cachep, uni);

which is all complete and utter bogosity. I have no idea why anybody
ever thought that was acceptable. It's garbage.

That "uni" isn't even a filename - of either kind. It's neither a
"struct filename" nor a PATH_MAX buffer. It's a "struct cpu_str *"
which is a UTF16 thing that has absolutely nothing to do with
names_cachep, and should never have been allocated that way. It's pure
random insanity.

It should just do a "kmalloc/kfree", with the size being 512 (255
UTF16 characters plus two bytes for len/unused).

Anyway, slightly updated patch that makes "names_cachep" local to
fs/namei.c just because there is absolutely _no_ reason for anybody
else to ever use it. Except for that insane legacy one of __getname(),
that is now just a kmalloc.

I also made EMBEDDED_NAME_MAX be 128 as per Mateusz' comment, although
to avoid double allocations it should probably be even bigger. A
"small" value is good for testing that the new logic works, though.

I haven't actually dared trying to boot into this, so it's still
entirely untested. But I've at least looked through that patch a bit
more and tried to search for other insane patterns, and so far that
oddity in ntfs3 was the only related thing I've found.

        Linus

--000000000000e22177064330cab3
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mhs9ybs10>
X-Attachment-Id: f_mhs9ybs10

IGZzL2RjYWNoZS5jICAgICAgICB8ICA4ICstLS0tCiBmcy9uYW1laS5jICAgICAgICAgfCA4NiAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGZz
L250ZnMzL25hbWVpLmMgICB8ICA0ICstLQogaW5jbHVkZS9saW51eC9mcy5oIHwgMTEgKysrLS0t
LQogNCBmaWxlcyBjaGFuZ2VkLCA1NCBpbnNlcnRpb25zKCspLCA1NSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9mcy9kY2FjaGUuYyBiL2ZzL2RjYWNoZS5jCmluZGV4IDAzNWNjY2JjOTI3Ni4u
YmQ0NDMyZjQ2ZDE1IDEwMDY0NAotLS0gYS9mcy9kY2FjaGUuYworKysgYi9mcy9kY2FjaGUuYwpA
QCAtMzI0NiwxMCArMzI0Niw2IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBkY2FjaGVfaW5pdCh2b2lk
KQogCXJ1bnRpbWVfY29uc3RfaW5pdChwdHIsIGRlbnRyeV9oYXNodGFibGUpOwogfQogCi0vKiBT
TEFCIGNhY2hlIGZvciBfX2dldG5hbWUoKSBjb25zdW1lcnMgKi8KLXN0cnVjdCBrbWVtX2NhY2hl
ICpuYW1lc19jYWNoZXAgX19yb19hZnRlcl9pbml0OwotRVhQT1JUX1NZTUJPTChuYW1lc19jYWNo
ZXApOwotCiB2b2lkIF9faW5pdCB2ZnNfY2FjaGVzX2luaXRfZWFybHkodm9pZCkKIHsKIAlpbnQg
aTsKQEAgLTMyNjMsOSArMzI1OSw3IEBAIHZvaWQgX19pbml0IHZmc19jYWNoZXNfaW5pdF9lYXJs
eSh2b2lkKQogCiB2b2lkIF9faW5pdCB2ZnNfY2FjaGVzX2luaXQodm9pZCkKIHsKLQluYW1lc19j
YWNoZXAgPSBrbWVtX2NhY2hlX2NyZWF0ZV91c2VyY29weSgibmFtZXNfY2FjaGUiLCBQQVRIX01B
WCwgMCwKLQkJCVNMQUJfSFdDQUNIRV9BTElHTnxTTEFCX1BBTklDLCAwLCBQQVRIX01BWCwgTlVM
TCk7Ci0KKwluYW1laV9pbml0KCk7CiAJZGNhY2hlX2luaXQoKTsKIAlpbm9kZV9pbml0KCk7CiAJ
ZmlsZXNfaW5pdCgpOwpkaWZmIC0tZ2l0IGEvZnMvbmFtZWkuYyBiL2ZzL25hbWVpLmMKaW5kZXgg
NzM3NzAyMGEyY2JhLi5hYWVkZTE4OTIxMzMgMTAwNjQ0Ci0tLSBhL2ZzL25hbWVpLmMKKysrIGIv
ZnMvbmFtZWkuYwpAQCAtMTIzLDcgKzEyMywyNiBAQAogICogUEFUSF9NQVggaW5jbHVkZXMgdGhl
IG51bCB0ZXJtaW5hdG9yIC0tUlIuCiAgKi8KIAotI2RlZmluZSBFTUJFRERFRF9OQU1FX01BWAko
UEFUSF9NQVggLSBvZmZzZXRvZihzdHJ1Y3QgZmlsZW5hbWUsIGluYW1lKSkKKy8qIFNMQUIgY2Fj
aGUgZm9yIGFsbG9jX2ZpbGVuYW1lKCkgY29uc3VtZXJzICovCitzdGF0aWMgc3RydWN0IGttZW1f
Y2FjaGUgKm5hbWVzX2NhY2hlcCBfX3JvX2FmdGVyX2luaXQ7CisKK3ZvaWQgX19pbml0IG5hbWVp
X2luaXQodm9pZCkKK3sKKwluYW1lc19jYWNoZXAgPSBrbWVtX2NhY2hlX2NyZWF0ZV91c2VyY29w
eSgibmFtZXNfY2FjaGUiLAorCQkJc2l6ZW9mKHN0cnVjdCBmaWxlbmFtZSksIDAsIFNMQUJfUEFO
SUMsCisJCQlvZmZzZXRvZihzdHJ1Y3QgZmlsZW5hbWUsIGluYW1lKSwgRU1CRURERURfTkFNRV9N
QVgsCisJCQlOVUxMKTsKK30KKworc3RhdGljIGlubGluZSBzdHJ1Y3QgZmlsZW5hbWUgKmFsbG9j
X2ZpbGVuYW1lKHZvaWQpCit7CisJcmV0dXJuIGttZW1fY2FjaGVfYWxsb2MobmFtZXNfY2FjaGVw
LCBHRlBfS0VSTkVMKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkIGZyZWVfZmlsZW5hbWUoc3Ry
dWN0IGZpbGVuYW1lICpuYW1lKQoreworCWttZW1fY2FjaGVfZnJlZShuYW1lc19jYWNoZXAsIG5h
bWUpOworfQogCiBzdGF0aWMgaW5saW5lIHZvaWQgaW5pdG5hbWUoc3RydWN0IGZpbGVuYW1lICpu
YW1lLCBjb25zdCBjaGFyIF9fdXNlciAqdXB0cikKIHsKQEAgLTE0Myw3ICsxNjIsNyBAQCBnZXRu
YW1lX2ZsYWdzKGNvbnN0IGNoYXIgX191c2VyICpmaWxlbmFtZSwgaW50IGZsYWdzKQogCWlmIChy
ZXN1bHQpCiAJCXJldHVybiByZXN1bHQ7CiAKLQlyZXN1bHQgPSBfX2dldG5hbWUoKTsKKwlyZXN1
bHQgPSBhbGxvY19maWxlbmFtZSgpOwogCWlmICh1bmxpa2VseSghcmVzdWx0KSkKIAkJcmV0dXJu
IEVSUl9QVFIoLUVOT01FTSk7CiAKQEAgLTE2MCw1NSArMTc5LDQyIEBAIGdldG5hbWVfZmxhZ3Mo
Y29uc3QgY2hhciBfX3VzZXIgKmZpbGVuYW1lLCBpbnQgZmxhZ3MpCiAJICovCiAJaWYgKHVubGlr
ZWx5KGxlbiA8PSAwKSkgewogCQlpZiAodW5saWtlbHkobGVuIDwgMCkpIHsKLQkJCV9fcHV0bmFt
ZShyZXN1bHQpOworCQkJZnJlZV9maWxlbmFtZShyZXN1bHQpOwogCQkJcmV0dXJuIEVSUl9QVFIo
bGVuKTsKIAkJfQogCiAJCS8qIFRoZSBlbXB0eSBwYXRoIGlzIHNwZWNpYWwuICovCiAJCWlmICgh
KGZsYWdzICYgTE9PS1VQX0VNUFRZKSkgewotCQkJX19wdXRuYW1lKHJlc3VsdCk7CisJCQlmcmVl
X2ZpbGVuYW1lKHJlc3VsdCk7CiAJCQlyZXR1cm4gRVJSX1BUUigtRU5PRU5UKTsKIAkJfQogCX0K
IAogCS8qCiAJICogVWgtb2guIFdlIGhhdmUgYSBuYW1lIHRoYXQncyBhcHByb2FjaGluZyBQQVRI
X01BWC4gQWxsb2NhdGUgYQotCSAqIHNlcGFyYXRlIHN0cnVjdCBmaWxlbmFtZSBzbyB3ZSBjYW4g
ZGVkaWNhdGUgdGhlIGVudGlyZQotCSAqIG5hbWVzX2NhY2hlIGFsbG9jYXRpb24gZm9yIHRoZSBw
YXRobmFtZSwgYW5kIHJlLWRvIHRoZSBjb3B5IGZyb20KLQkgKiB1c2VybGFuZC4KKwkgKiBzZXBh
cmF0ZSBwYXRobmFtZSwgY29weSB0aGUgcGFydGlhbCByZXN1bHQgd2UgYWxyZWFkeSBkaWQsIGFu
ZAorCSAqIHRoZW4gY29weSB0aGUgcmVzdCBvZiB0aGUgcGF0aG5hbWUgZnJvbSB1c2VyIHNwYWNl
LgogCSAqLwogCWlmICh1bmxpa2VseShsZW4gPT0gRU1CRURERURfTkFNRV9NQVgpKSB7Ci0JCWNv
bnN0IHNpemVfdCBzaXplID0gb2Zmc2V0b2Yoc3RydWN0IGZpbGVuYW1lLCBpbmFtZVsxXSk7Ci0J
CWtuYW1lID0gKGNoYXIgKilyZXN1bHQ7Ci0KLQkJLyoKLQkJICogc2l6ZSBpcyBjaG9zZW4gdGhh
dCB3YXkgd2UgdG8gZ3VhcmFudGVlIHRoYXQKLQkJICogcmVzdWx0LT5pbmFtZVswXSBpcyB3aXRo
aW4gdGhlIHNhbWUgb2JqZWN0IGFuZCB0aGF0Ci0JCSAqIGtuYW1lIGNhbid0IGJlIGVxdWFsIHRv
IHJlc3VsdC0+aW5hbWUsIG5vIG1hdHRlciB3aGF0LgotCQkgKi8KLQkJcmVzdWx0ID0ga3phbGxv
YyhzaXplLCBHRlBfS0VSTkVMKTsKLQkJaWYgKHVubGlrZWx5KCFyZXN1bHQpKSB7Ci0JCQlfX3B1
dG5hbWUoa25hbWUpOworCQlrbmFtZSA9IGttYWxsb2MoUEFUSF9NQVgsIEdGUF9LRVJORUwpOwor
CQlpZiAodW5saWtlbHkoIWtuYW1lKSkgeworCQkJZnJlZV9maWxlbmFtZShyZXN1bHQpOwogCQkJ
cmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7CiAJCX0KLQkJcmVzdWx0LT5uYW1lID0ga25hbWU7Ci0J
CWxlbiA9IHN0cm5jcHlfZnJvbV91c2VyKGtuYW1lLCBmaWxlbmFtZSwgUEFUSF9NQVgpOworCQlt
ZW1jcHkoa25hbWUsIHJlc3VsdC0+aW5hbWUsIEVNQkVEREVEX05BTUVfTUFYKTsKKworCQkvLyBD
b3B5IHJlbWFpbmluZyBwYXJ0IG9mIHRoZSBuYW1lCisJCWxlbiA9IHN0cm5jcHlfZnJvbV91c2Vy
KGtuYW1lICsgRU1CRURERURfTkFNRV9NQVgsCisJCQlmaWxlbmFtZSArIEVNQkVEREVEX05BTUVf
TUFYLAorCQkJUEFUSF9NQVgtRU1CRURERURfTkFNRV9NQVgpOworCQlpZiAodW5saWtlbHkobGVu
ID09IFBBVEhfTUFYLUVNQkVEREVEX05BTUVfTUFYKSkKKwkJCWxlbiA9IC1FTkFNRVRPT0xPTkc7
CiAJCWlmICh1bmxpa2VseShsZW4gPCAwKSkgewotCQkJX19wdXRuYW1lKGtuYW1lKTsKLQkJCWtm
cmVlKHJlc3VsdCk7CisJCQlmcmVlX2ZpbGVuYW1lKHJlc3VsdCk7CisJCQlrZnJlZShrbmFtZSk7
CiAJCQlyZXR1cm4gRVJSX1BUUihsZW4pOwogCQl9Ci0JCS8qIFRoZSBlbXB0eSBwYXRoIGlzIHNw
ZWNpYWwuICovCi0JCWlmICh1bmxpa2VseSghbGVuKSAmJiAhKGZsYWdzICYgTE9PS1VQX0VNUFRZ
KSkgewotCQkJX19wdXRuYW1lKGtuYW1lKTsKLQkJCWtmcmVlKHJlc3VsdCk7Ci0JCQlyZXR1cm4g
RVJSX1BUUigtRU5PRU5UKTsKLQkJfQotCQlpZiAodW5saWtlbHkobGVuID09IFBBVEhfTUFYKSkg
ewotCQkJX19wdXRuYW1lKGtuYW1lKTsKLQkJCWtmcmVlKHJlc3VsdCk7Ci0JCQlyZXR1cm4gRVJS
X1BUUigtRU5BTUVUT09MT05HKTsKLQkJfQorCQlyZXN1bHQtPm5hbWUgPSBrbmFtZTsKIAl9CiAJ
aW5pdG5hbWUocmVzdWx0LCBmaWxlbmFtZSk7CiAJYXVkaXRfZ2V0bmFtZShyZXN1bHQpOwpAQCAt
MjQ2LDcgKzI1Miw3IEBAIHN0cnVjdCBmaWxlbmFtZSAqZ2V0bmFtZV9rZXJuZWwoY29uc3QgY2hh
ciAqIGZpbGVuYW1lKQogCXN0cnVjdCBmaWxlbmFtZSAqcmVzdWx0OwogCWludCBsZW4gPSBzdHJs
ZW4oZmlsZW5hbWUpICsgMTsKIAotCXJlc3VsdCA9IF9fZ2V0bmFtZSgpOworCXJlc3VsdCA9IGFs
bG9jX2ZpbGVuYW1lKCk7CiAJaWYgKHVubGlrZWx5KCFyZXN1bHQpKQogCQlyZXR1cm4gRVJSX1BU
UigtRU5PTUVNKTsKIApAQCAtMjU4LDEzICsyNjQsMTMgQEAgc3RydWN0IGZpbGVuYW1lICpnZXRu
YW1lX2tlcm5lbChjb25zdCBjaGFyICogZmlsZW5hbWUpCiAKIAkJdG1wID0ga21hbGxvYyhzaXpl
LCBHRlBfS0VSTkVMKTsKIAkJaWYgKHVubGlrZWx5KCF0bXApKSB7Ci0JCQlfX3B1dG5hbWUocmVz
dWx0KTsKKwkJCWZyZWVfZmlsZW5hbWUocmVzdWx0KTsKIAkJCXJldHVybiBFUlJfUFRSKC1FTk9N
RU0pOwogCQl9CiAJCXRtcC0+bmFtZSA9IChjaGFyICopcmVzdWx0OwogCQlyZXN1bHQgPSB0bXA7
CiAJfSBlbHNlIHsKLQkJX19wdXRuYW1lKHJlc3VsdCk7CisJCWZyZWVfZmlsZW5hbWUocmVzdWx0
KTsKIAkJcmV0dXJuIEVSUl9QVFIoLUVOQU1FVE9PTE9ORyk7CiAJfQogCW1lbWNweSgoY2hhciAq
KXJlc3VsdC0+bmFtZSwgZmlsZW5hbWUsIGxlbik7CkBAIC0yOTAsMTEgKzI5Niw5IEBAIHZvaWQg
cHV0bmFtZShzdHJ1Y3QgZmlsZW5hbWUgKm5hbWUpCiAJCQlyZXR1cm47CiAJfQogCi0JaWYgKG5h
bWUtPm5hbWUgIT0gbmFtZS0+aW5hbWUpIHsKLQkJX19wdXRuYW1lKG5hbWUtPm5hbWUpOwotCQlr
ZnJlZShuYW1lKTsKLQl9IGVsc2UKLQkJX19wdXRuYW1lKG5hbWUpOworCWlmIChuYW1lLT5uYW1l
ICE9IG5hbWUtPmluYW1lKQorCQlrZnJlZShuYW1lLT5uYW1lKTsKKwlmcmVlX2ZpbGVuYW1lKG5h
bWUpOwogfQogRVhQT1JUX1NZTUJPTChwdXRuYW1lKTsKIApkaWZmIC0tZ2l0IGEvZnMvbnRmczMv
bmFtZWkuYyBiL2ZzL250ZnMzL25hbWVpLmMKaW5kZXggODJjOGFlNTZiZWVlLi41ZGRiZmUxN2Q4
ZTMgMTAwNjQ0Ci0tLSBhL2ZzL250ZnMzL25hbWVpLmMKKysrIGIvZnMvbnRmczMvbmFtZWkuYwpA
QCAtNDA3LDcgKzQwNyw3IEBAIHN0YXRpYyBpbnQgbnRmc19kX2hhc2goY29uc3Qgc3RydWN0IGRl
bnRyeSAqZGVudHJ5LCBzdHJ1Y3QgcXN0ciAqbmFtZSkKIAkvKgogCSAqIFRyeSBzbG93IHdheSB3
aXRoIGN1cnJlbnQgdXBjYXNlIHRhYmxlCiAJICovCi0JdW5pID0ga21lbV9jYWNoZV9hbGxvYyhu
YW1lc19jYWNoZXAsIEdGUF9OT1dBSVQpOworCXVuaSA9IGttYWxsb2MoMiooTlRGU19OQU1FX0xF
TiArIDEpLCBHRlBfTk9XQUlUKTsKIAlpZiAoIXVuaSkKIAkJcmV0dXJuIC1FTk9NRU07CiAKQEAg
LTQyOSw3ICs0MjksNyBAQCBzdGF0aWMgaW50IG50ZnNfZF9oYXNoKGNvbnN0IHN0cnVjdCBkZW50
cnkgKmRlbnRyeSwgc3RydWN0IHFzdHIgKm5hbWUpCiAJZXJyID0gMDsKIAogb3V0OgotCWttZW1f
Y2FjaGVfZnJlZShuYW1lc19jYWNoZXAsIHVuaSk7CisJa2ZyZWUodW5pKTsKIAlyZXR1cm4gZXJy
OwogfQogCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2ZzLmggYi9pbmNsdWRlL2xpbnV4L2Zz
LmgKaW5kZXggYzk1ODhkNTU1ZjczLi45ZDQ3MDdiYmM4M2EgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bGludXgvZnMuaAorKysgYi9pbmNsdWRlL2xpbnV4L2ZzLmgKQEAgLTgxLDYgKzgxLDcgQEAgc3Ry
dWN0IGZzX3BhcmFtZXRlcl9zcGVjOwogc3RydWN0IGZpbGVfa2F0dHI7CiBzdHJ1Y3QgaW9tYXBf
b3BzOwogCitleHRlcm4gdm9pZCBfX2luaXQgbmFtZWlfaW5pdCh2b2lkKTsKIGV4dGVybiB2b2lk
IF9faW5pdCBpbm9kZV9pbml0KHZvaWQpOwogZXh0ZXJuIHZvaWQgX19pbml0IGlub2RlX2luaXRf
ZWFybHkodm9pZCk7CiBleHRlcm4gdm9pZCBfX2luaXQgZmlsZXNfaW5pdCh2b2lkKTsKQEAgLTI4
MzQsMTIgKzI4MzUsMTMgQEAgZXh0ZXJuIHN0cnVjdCBrb2JqZWN0ICpmc19rb2JqOwogCiAvKiBm
cy9vcGVuLmMgKi8KIHN0cnVjdCBhdWRpdF9uYW1lczsKKyNkZWZpbmUgRU1CRURERURfTkFNRV9N
QVgJMTI4CiBzdHJ1Y3QgZmlsZW5hbWUgewogCWNvbnN0IGNoYXIJCSpuYW1lOwkvKiBwb2ludGVy
IHRvIGFjdHVhbCBzdHJpbmcgKi8KIAljb25zdCBfX3VzZXIgY2hhcgkqdXB0cjsJLyogb3JpZ2lu
YWwgdXNlcmxhbmQgcG9pbnRlciAqLwogCWF0b21pY190CQlyZWZjbnQ7CiAJc3RydWN0IGF1ZGl0
X25hbWVzCSphbmFtZTsKLQljb25zdCBjaGFyCQlpbmFtZVtdOworCWNvbnN0IGNoYXIJCWluYW1l
W0VNQkVEREVEX05BTUVfTUFYXTsKIH07CiBzdGF0aWNfYXNzZXJ0KG9mZnNldG9mKHN0cnVjdCBm
aWxlbmFtZSwgaW5hbWUpICUgc2l6ZW9mKGxvbmcpID09IDApOwogCkBAIC0yOTU5LDEwICsyOTYx
LDkgQEAgc3RhdGljIGlubGluZSBpbnQgZmluaXNoX29wZW5fc2ltcGxlKHN0cnVjdCBmaWxlICpm
aWxlLCBpbnQgZXJyb3IpCiBleHRlcm4gdm9pZCBfX2luaXQgdmZzX2NhY2hlc19pbml0X2Vhcmx5
KHZvaWQpOwogZXh0ZXJuIHZvaWQgX19pbml0IHZmc19jYWNoZXNfaW5pdCh2b2lkKTsKIAotZXh0
ZXJuIHN0cnVjdCBrbWVtX2NhY2hlICpuYW1lc19jYWNoZXA7Ci0KLSNkZWZpbmUgX19nZXRuYW1l
KCkJCWttZW1fY2FjaGVfYWxsb2MobmFtZXNfY2FjaGVwLCBHRlBfS0VSTkVMKQotI2RlZmluZSBf
X3B1dG5hbWUobmFtZSkJCWttZW1fY2FjaGVfZnJlZShuYW1lc19jYWNoZXAsICh2b2lkICopKG5h
bWUpKQorLy8gQ3Jhenkgb2xkIGxlZ2FjeSB1c2VzIGZvciBwYXRobmFtZSBhbGxvY2F0aW9ucwor
I2RlZmluZSBfX2dldG5hbWUoKSBrbWFsbG9jKFBBVEhfTUFYLCBHRlBfS0VSTkVMKQorI2RlZmlu
ZSBfX3B1dG5hbWUobmFtZSkga2ZyZWUoKHZvaWQgKikobmFtZSkpCiAKIGV4dGVybiBzdHJ1Y3Qg
c3VwZXJfYmxvY2sgKmJsb2NrZGV2X3N1cGVyYmxvY2s7CiBzdGF0aWMgaW5saW5lIGJvb2wgc2Jf
aXNfYmxrZGV2X3NiKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCg==
--000000000000e22177064330cab3--

