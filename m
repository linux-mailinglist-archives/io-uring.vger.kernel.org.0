Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130C2428D68
	for <lists+io-uring@lfdr.de>; Mon, 11 Oct 2021 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbhJKM6b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Oct 2021 08:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhJKM6a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Oct 2021 08:58:30 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6818C061570
        for <io-uring@vger.kernel.org>; Mon, 11 Oct 2021 05:56:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so10738490pgc.6
        for <io-uring@vger.kernel.org>; Mon, 11 Oct 2021 05:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8p07T4/eNH9lRQKlyEWVWxuUlzFw2g6fziR0tKVH/I=;
        b=Jn0yJnxUF0EPkHcYMY3Ocx4s1rtJxA76uB60YrnB8N4+NLp/fYJSJ/To2U3+8kEGkv
         mg3drN8lk/jD/YnLC+cDkBJA6NIjigUA+fMQve0w4ful6esSNqbVBoaqc4iZLUqSLZSW
         ApuujO3cPy3Fxzji/0NR5ZnslmSD1O+D3jyHpOtYuvjcQqfBmPZQ4aOqG3ZAk9Q5At3h
         mEFLlJedtt7KAeBDnIBKv0jRoYzUxh8wl6Wz5Q5/yADVw4Zvurts2/nMIRPCpoTr8r2c
         WwCxbj5/hBKiSIbBsJi2/vnLMOoq4zKanc91AB5Ztnxu45hfkpHiPv4AhT+yhS9ewqNc
         qWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8p07T4/eNH9lRQKlyEWVWxuUlzFw2g6fziR0tKVH/I=;
        b=1INyof0n5oTJLHdcTgsOS8Q+efzESKXOIheujXNDmF222PFSrOteXGbffpDWKgWzvV
         O7NMzImXOi624Shdz83EWFJrZ1jfSvIwQM7wbziRy2Ek+FVA3A2+htSKBXTocz1k/wWF
         /MmmR9L+YRuz6WvhTrxHzcMGc/K74jVbmmvXWwkeyioeqSDy3oJ0DB4i5gV9iFx5S95L
         WykDliBu7P0r9buczeZezOsbnefe9w7wnU7Hb2mpG62IeLH6EzQUi992N3rv+11Y4QS/
         VsvQb/kml9puPcDKPsoIhCEef+15To+wGQLa6CKhcDL04Va92QnKWynz1n+LIyGqXMjt
         NWpA==
X-Gm-Message-State: AOAM532nhhDIdiwVh7piKy4D5QM3R+IxGwlDo/GtRQnUb2uuOnPJniK4
        hAafxwyhL/Whi2JaT4gz3lSA0A==
X-Google-Smtp-Source: ABdhPJzwyvH/p0R/eX4iB3CgWt4FaD7MqR/cOMLsMuDiMfb9U0Kp1GkOmf0PZIsh2nopVC7eBJfm6Q==
X-Received: by 2002:a05:6a00:140c:b0:447:96be:2ade with SMTP id l12-20020a056a00140c00b0044796be2ademr25281230pfu.26.1633956988251;
        Mon, 11 Oct 2021 05:56:28 -0700 (PDT)
Received: from integral.. ([182.2.73.156])
        by smtp.gmail.com with ESMTPSA id z124sm7916957pfb.108.2021.10.11.05.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 05:56:27 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: Re: [PATCH liburing] src/nolibc: Fix `malloc()` alignment
Date:   Mon, 11 Oct 2021 19:56:08 +0700
Message-Id: <20211011125608.487082-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ae6aa009-765a-82b0-022c-d6696c6d3ee2@kernel.dk>
References: <ae6aa009-765a-82b0-022c-d6696c6d3ee2@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 11, 2021 at 7:13 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/11/21 12:49 AM, Ammar Faizi wrote:
> > Add `__attribute__((__aligned__))` to the `user_p` to guarantee
> > pointer returned by the `malloc()` is properly aligned for user.
> >
> > This attribute asks the compiler to align a type to the maximum
> > useful alignment for the target machine we are compiling for,
> > which is often, but by no means always, 8 or 16 bytes [1].
> >
> > Link: https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Common-Variable-Attributes.html#Common-Variable-Attributes [1]
> > Fixes: https://github.com/axboe/liburing/issues/454
> > Reported-by: Louvian Lyndal <louvianlyndal@gmail.com>
> > Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> > ---
> >  src/nolibc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/src/nolibc.c b/src/nolibc.c
> > index 5582ca0..251780b 100644
> > --- a/src/nolibc.c
> > +++ b/src/nolibc.c
> > @@ -20,7 +20,7 @@ void *memset(void *s, int c, size_t n)
> >
> >  struct uring_heap {
> >       size_t          len;
> > -     char            user_p[];
> > +     char            user_p[] __attribute__((__aligned__));
> >  };
>
> This seems to over-align for me, at 16 bytes where 8 bytes would be fine.
> What guarantees does malloc() give?
>

Section 7.20.3 of C99 states this about `malloc()`:
__The pointer returned if the allocation succeeds is suitably aligned
so that it may be assigned to a pointer to any type of object.__

I have just browsed the glibc source code, malloc does give us 16 bytes
alignment guarantee on x86-64. 

https://code.woboq.org/userspace/glibc/sysdeps/generic/malloc-alignment.h.html#_M/MALLOC_ALIGNMENT

Lookie here on Linux x86-64...

```
ammarfaizi2@integral:/tmp$ cat > test.c
#include <stdio.h>
int main(void)
{
	printf("alignof = %zu\n", __alignof__(long double));
	return 0;
}
ammarfaizi2@integral:/tmp$ gcc -o test test.c
ammarfaizi2@integral:/tmp$ ./test
alignof = 16
ammarfaizi2@integral:/tmp$ 
```

We have `long double` which requires 16 byte alignment. So `malloc()`
should cover this. Although we don't use floating point in liburing,
it's probably better to have this guarantee as well?

What do you think?
Will we ever need this?


Currently we only use it for probe ring func, so 8 bytes is fine:
```
struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
{
	struct io_uring_probe *probe;
	size_t len;
	int r;

	len = sizeof(*probe) + 256 * sizeof(struct io_uring_probe_op);
	probe = malloc(len);
	if (!probe)
		return NULL;
	memset(probe, 0, len);

	r = io_uring_register_probe(ring, probe, 256);
	if (r >= 0)
		return probe;

	free(probe);
	return NULL;
}
```

I will send v2 to make it 8 byte aligned if you think it better to do
so.

-- 
Ammar Faizi
