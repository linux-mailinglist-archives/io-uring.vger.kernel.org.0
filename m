Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F1D2F8FE0
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 00:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbhAPXf7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 18:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbhAPXf6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 18:35:58 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C7DC061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:35:17 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id s26so18694784lfc.8
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UZ38r+/gsoHTtBCHwFb6I22MCaZ8Wyubo4I/C6GrSrE=;
        b=QFIBCIp8yLJL+h/84B9eg78CZR2FcQ8Kvgn8P49exEWhWIV2Py2usu78oKkeLmRB4/
         DrSTZpLeuMOc0eS9kwkL6lA5bza45jfjSQhO43Iby4bR+Vs1NecOsJV94TrAVLPl2fzz
         B5SnsxzKkOhEbKGk2e1IaZpI1ShGTbeN5b9/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UZ38r+/gsoHTtBCHwFb6I22MCaZ8Wyubo4I/C6GrSrE=;
        b=gdFWIrmcKopzEjTuTXJPzSK2baJuznFMOl7FTheIt79ntJgvgS9MWB0xJYxQfvrYEf
         BKgw74OVjjXa5wmfV+Pt0tfsz+XDEwx/Y4Vyxwl31qXdNbhGRKGYp+Ypy05eXeqwuacM
         kHk19jihDYgKaylN7G8/GBXJX1No5xDAcyZ7Wz8HyaDpnvEhDrp3gwUAnj8yOjCg2D1m
         dBELDHhin/iC2Pa7cZ5Pp/V5u+4iLLYMLJnNMGzjbaikdHUVpuGu80roNb9/zrrqG9h1
         3lNU2ALQigtbEz6Lm1o4pAXxFouFRLxucQ49bILYY9ze581fwYMmHuq0dy93Fei2xlQb
         2pkQ==
X-Gm-Message-State: AOAM530W57LcPukwUDm7qACCq7Qdtf5z4rgVrIZ9kyq36dudYMh3atMV
        dgZa4nKil0v4a07j9WJbPM4YDLMmlEYZjw==
X-Google-Smtp-Source: ABdhPJwcOeEdt4v9vH14wwXIwKQ0e/2jfA7RQtjrAWqaOhUm2WbXFC8fx7SMHzVd2DY1iNFHJ3dZig==
X-Received: by 2002:ac2:5551:: with SMTP id l17mr5226875lfk.590.1610840115932;
        Sat, 16 Jan 2021 15:35:15 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id z17sm1409739lfg.275.2021.01.16.15.35.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 15:35:14 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id m13so14352073ljo.11
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:35:13 -0800 (PST)
X-Received: by 2002:a2e:6f17:: with SMTP id k23mr7730682ljc.411.1610840113348;
 Sat, 16 Jan 2021 15:35:13 -0800 (PST)
MIME-Version: 1.0
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk> <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com> <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
 <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
 <61566b44-fe88-03b0-fd94-70acfc82c093@kernel.dk> <CAHk-=wh3Agdy3h+rsx5HTOWt6dS-jN9THBqNhk=mWG4KnCK0tw@mail.gmail.com>
In-Reply-To: <CAHk-=wh3Agdy3h+rsx5HTOWt6dS-jN9THBqNhk=mWG4KnCK0tw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 16 Jan 2021 15:34:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiGEFZf-+YXcUVDj_mutwG6qWZzKUKZ-5yQ5UWgLGrBNQ@mail.gmail.com>
Message-ID: <CAHk-=wiGEFZf-+YXcUVDj_mutwG6qWZzKUKZ-5yQ5UWgLGrBNQ@mail.gmail.com>
Subject: Re: Fixed buffers have out-dated content
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Martin Raiber <martin@urbackup.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000bf207605b90cf01a"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000bf207605b90cf01a
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 16, 2021 at 3:05 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll go think about this.
>
> Martin, since you can apparently trigger the problem easily, hopefully
> you're willing to try a couple of patches?

Hmm. It might end up being as simple as the attached patch.

I'm not super-happy with this situation (that whole nasty security
issue had some horrible cascading problems), and this only really
fixes _pinned_ pages.

In particular, somebody doing a plain get_user_pages() for writing can
still hit issues (admittedly that's true in general, but the vm
changes made it much more obviously true).

But for the case of io_uring buffers, this looks like the obvious simple fix.

I don't have a load to test this with, so I'll come back to ask Martin
to do so...

                 Linus

--000000000000bf207605b90cf01a
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kk0clhsw0>
X-Attachment-Id: f_kk0clhsw0

IG1tL3Ztc2Nhbi5jIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL21tL3Ztc2Nhbi5jIGIvbW0vdm1zY2FuLmMKaW5kZXggMjU3Y2JhNzlhOTZkLi5i
MWI1NzRhZDE5OWQgMTAwNjQ0Ci0tLSBhL21tL3Ztc2Nhbi5jCisrKyBiL21tL3Ztc2Nhbi5jCkBA
IC0xMjM4LDYgKzEyMzgsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHNocmlua19wYWdlX2xpc3Qo
c3RydWN0IGxpc3RfaGVhZCAqcGFnZV9saXN0LAogCQkJaWYgKCFQYWdlU3dhcENhY2hlKHBhZ2Up
KSB7CiAJCQkJaWYgKCEoc2MtPmdmcF9tYXNrICYgX19HRlBfSU8pKQogCQkJCQlnb3RvIGtlZXBf
bG9ja2VkOworCQkJCWlmIChwYWdlX21heWJlX2RtYV9waW5uZWQocGFnZSkpCisJCQkJCWdvdG8g
a2VlcF9sb2NrZWQ7CiAJCQkJaWYgKFBhZ2VUcmFuc0h1Z2UocGFnZSkpIHsKIAkJCQkJLyogY2Fu
bm90IHNwbGl0IFRIUCwgc2tpcCBpdCAqLwogCQkJCQlpZiAoIWNhbl9zcGxpdF9odWdlX3BhZ2Uo
cGFnZSwgTlVMTCkpCg==
--000000000000bf207605b90cf01a--
