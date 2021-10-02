Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B9F41FA87
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 11:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhJBJIQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 05:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhJBJIH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 05:08:07 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60CBC061570
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 02:06:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id n18so11664084pgm.12
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 02:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MkUoG9p5/Wh2ZuqTLEB5JdXHcjFTs+sQhdoq6CdorvU=;
        b=ROfS28cz/FCWR55OGMpIsXXj8pflhdjCt1gfK3hiIio5DSVUkw3p0NwK0lnpGT+NVF
         FRiFMC4ZYlahqw+/Gj5gFd5Z//N9RmXS6iDbhFAXPLujYU60OApk9iIY9Uy/iI5ntky9
         hNiwHSQDJPmwf/N13k71vTQ2/OWepkQm2QbEaRX4DuNfcjyGLrPUsJi4737MQ6/xztKa
         8BFKoU5xmEQpgLtVdKhkDgCNZfh4OBG355M7AzhIqfcD/QlO2D1TwaFeMrNiSbPJzqp0
         6wcxToUojk24pvqpohop8U9AI1JCciHRyBnBUwRMtzK5hmP0E2/raFJH+MtRK/ynXucq
         9Rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MkUoG9p5/Wh2ZuqTLEB5JdXHcjFTs+sQhdoq6CdorvU=;
        b=sv4UMq+ANxJh0Af1fE45Gx6gLD/+gN09lPrlBtUNttl/keAHXmN1ZbnfKAxvmLbQgR
         o2PHNY6jvfXZ+j2MgvYFx1XRNWXmvXP+mpAapLUeXI+uF+T3MEyEIOjb6al4LkHBssft
         WldZfGo51o5VIkmMJYypi+ghPJwTmmgqe6zp6p2gHF1lypROBYpd4c4LLV0P5gO9iELo
         lELW5aGNkAknx6IcQZP2WaHAMMV6jqyBHkm1T/qfHsGVWrcRGVIR054/Dviia53VR/3e
         VTCZ7B2eu62t8FikJAXq+tM9AJ4wfyI+B6/3STJ3YCgaaiKsncYDDOaPy+jJSeeyRCyC
         eyOg==
X-Gm-Message-State: AOAM532ROjn1fwBDWFxzuqTzDoKJvV/u3MVMYaGv+oF3n4tHXiraxJoG
        TlBLakvdQlj8Mt9UUa5hju05Xw==
X-Google-Smtp-Source: ABdhPJzIFBQZXANRW3AxzsdlIay8YnbAAQF4b5QOLJXQzPv276AUpZ1lfFFaWAs63zJRv5m7joopLw==
X-Received: by 2002:a63:f050:: with SMTP id s16mr2125911pgj.258.1633165581238;
        Sat, 02 Oct 2021 02:06:21 -0700 (PDT)
Received: from integral.. ([182.2.69.211])
        by smtp.gmail.com with ESMTPSA id x20sm7746201pjp.48.2021.10.02.02.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 02:06:20 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Louvian Lyndal <louvianlyndal@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ammar Faizi <ammarfaizi2@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
Subject: Re: [PATCH v3 RFC liburing 2/4] src/{queue,register,setup}: Don't use `__sys_io_uring*`
Date:   Sat,  2 Oct 2021 16:04:48 +0700
Message-Id: <20211002090448.205625-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <d760c684-8175-6647-01c5-f0107b6685c6@gmail.com>
References: <d760c684-8175-6647-01c5-f0107b6685c6@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Oct 2, 2021 at 3:12 PM Louvian Lyndal <louvianlyndal@gmail.com> wrote:
>
> On 10/2/21 8:48 AM, Ammar Faizi wrote:
> > @@ -158,7 +142,7 @@ int io_uring_register_files_tags(struct io_uring *ring,
> >               break;
> >       } while (1);
> >  
> > -     return ret < 0 ? -errno : ret;
> > +     return (ret < 0) ? ret : 0;
> >   }
>
> This is wrong, you changed the logic, should've been "return ret;".
> Not all successful call returns 0.
>
> >  
> >   int io_uring_register_files(struct io_uring *ring, const int *files,
> > @@ -167,12 +151,12 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
> >       int ret, did_increase = 0;
> >  
> >       do {
> > -             ret = __sys_io_uring_register(ring->ring_fd,
> > -                                           IORING_REGISTER_FILES, files,
> > -                                           nr_files);
> > +             ret = ____sys_io_uring_register(ring->ring_fd,
> > +                                             IORING_REGISTER_FILES, files,
> > +                                             nr_files);
> >               if (ret >= 0)
> >                       break;
> > -             if (errno == EMFILE && !did_increase) {
> > +             if (ret == -EMFILE && !did_increase) {
> >                       did_increase = 1;
> >                       increase_rlimit_nofile(nr_files);
> >                       continue;
> > @@ -180,55 +164,44 @@ int io_uring_register_files(struct io_uring *ring, const int *files,
> >               break;
> >       } while (1);
> >  
> > -     return ret < 0 ? -errno : ret;
> > +     return (ret < 0) ? ret : 0;
> >   }
>
> The same thing here!
>
> --
> Louvian Lyndal

Ack, that changed the logic. I missed that, will fix this for v4.

Not an excuse, but the test did not fail from my end.

Looking at test/test_update_multiring.c:71 on test_update_multiring():
```
  if (io_uring_register_files(r1, fds, 10) ||
      io_uring_register_files(r2, fds, 10) ||
      io_uring_register_files(r3, fds, 10)) {
        fprintf(stderr, "%s: register files failed\n", __FUNCTION__);
        goto err;
  }
```
Based on this one, this function is expected to return 0. When it
returns non zero value, it will go to err. So it won't really change
the situation.

In anyway, it's a fact that I changed the logic, I admit that and will
get it fixed.

Thanks!

-- 
Ammar Faizi
