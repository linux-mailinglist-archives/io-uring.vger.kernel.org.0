Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F06226C65
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 18:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgGTQu0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 12:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgGTQuZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 12:50:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49520C061794;
        Mon, 20 Jul 2020 09:50:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so199691wmh.2;
        Mon, 20 Jul 2020 09:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C4b8qhvwAjwGhT6JyfXt5H1f2fkHwdgJiTZMLInpoWY=;
        b=GgOnivf6O+qwfUQUg2D0y3V0uajSxUn+4a5Q0Y5M//QasuxiU8RHZZn1QL0HBjDCbl
         iUAfDLFaqvv8m0HXaPekB/UL3aUJHgT371PTLFy2LuffToVmY93vEXxpjdkoggrcDtRF
         Un03YyD+9nc+MZA39zGLDH/J3s4J6xxPPe0IeVxW8L79nBV2HJggUcfSQur+WGv7ilXA
         fe8YI85YZfKb9CbDfxloBSKCAu3h5PtcGaQdXdT3ztcqhrBfazl31QLCX3x7UN3UaNyf
         XP5bPuN2AHaA2KxUwSltX5CLE+zZ84QPu3yaHrqZmHGDo6mEv5zFFxzVYGp/fLkhuDTl
         mN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C4b8qhvwAjwGhT6JyfXt5H1f2fkHwdgJiTZMLInpoWY=;
        b=WflUH8LMEhdFv85KNuhOXKFHEfMGx/E/+L2OMcIjxe7Kgx02+itPyQWLF7m3wdDZQu
         bE82LbXCgv14RNs4WBO+d4hbu5/NSKbeZnFDA6hvGoQHywUkltbYDiGci+536DhEpXow
         sSUAx8IMLZG/xjVUibGB+NVOoVcGdI3zsYY2u3ZOmfcRbfvJMnzv83SBVq3VuiMgKmgL
         rW+q5BgWh+DnQ5BJR9hkl4eTzXTh3a1R5h7RpOyd+2YAYTuYvBHSKlhZfVM1zT26vH76
         zqNkmuQm1/rXz+KfndDj/IK5u8BMpvRjffD/L8EQ9LxxMmfXD7qw/QUUfnFw6W+BwxBV
         nUqQ==
X-Gm-Message-State: AOAM530fMwpdjW0T4LA5m3n3CTaH9mPqRhKtxzeCA3PjP42SlOXugtMQ
        tjN2KCL3D9Z91swOkFoqA6v8e5P0w5WNcq2+lLU=
X-Google-Smtp-Source: ABdhPJwFSzZ/u8TUd7I2y8wpKszzOhMiqh0+Orsk3QC9nGTrARDpeWv0iNp2kQSTc2PonZjZuA78BWemRwKJT3Y9w/o=
X-Received: by 2002:a1c:2485:: with SMTP id k127mr231539wmk.138.1595263823888;
 Mon, 20 Jul 2020 09:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org> <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org> <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
In-Reply-To: <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 20 Jul 2020 22:19:57 +0530
Message-ID: <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, "Matias Bj??rling" <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 7:41 PM Kanchan Joshi <joshiiitr@gmail.com> wrote:
>
> On Fri, Jul 10, 2020 at 7:21 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Jul 10, 2020 at 02:49:32PM +0100, Christoph Hellwig wrote:
> > > On Fri, Jul 10, 2020 at 02:48:24PM +0100, Matthew Wilcox wrote:
> > > > If we're going to go the route of changing the CQE, how about:
> > > >
> > > >  struct io_uring_cqe {
> > > >          __u64   user_data;      /* sqe->data submission passed back */
> > > > -        __s32   res;            /* result code for this event */
> > > > -        __u32   flags;
> > > > +   union {
> > > > +           struct {
> > > > +                   __s32   res;            /* result code for this event */
> > > > +                   __u32   flags;
> > > > +           };
> > > > +           __s64   res64;
> > > > +   };
> > > >  };
> > > >
> > > > then we don't need to change the CQE size and it just depends on the SQE
> > > > whether the CQE for it uses res+flags or res64.
> > >
> > > How do you return a status code or short write when you just have
> > > a u64 that is needed for the offset?
> >
> > it's an s64 not a u64 so you can return a negative errno.  i didn't
> > think we allowed short writes for objects-which-have-a-pos.
>
> If we are doing this for zone-append (and not general cases), "__s64
> res64" should work -.
> 64 bits = 1 (sign) + 23 (bytes-copied: cqe->res) + 40
> (written-location: chunk_sector bytes limit)

And this is for the scheme when single CQE is used with bits
refactoring into "_s64 res64" instead of res/flags.

41 bits for zone-append completion = in bytes, sufficient to cover
chunk_sectors size zone
1+22 bits for zone-append bytes-copied = can cover 4MB bytes copied
(single I/O is capped at 4MB in NVMe)

+ * zone-append specific flags
+#define APPEND_OFFSET_BITS     (41)
+#define APPEND_RES_BITS                (23)
+
+/*
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-       __u64   user_data;      /* sqe->data submission passed back */
-       __s32   res;            /* result code for this event */
-       __u32   flags;
+       __u64   user_data;      /* sqe->data submission passed back */
+        union {
+                struct {
+                        __s32   res;            /* result code for
this event */
+                        __u32   flags;
+                };
+               /* Alternate for zone-append */
+               struct {
+                       union {
+                               /*
+                                * kernel uses this to store append result
+                                * Most significant 23 bits to return number of
+                                * bytes or error, and least significant 41 bits
+                                * to return zone-relative offset in bytes
+                                * */
+                               __s64 res64;
+                               /*for user-space ease, kernel does not use*/
+                               struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+                                       __u64 append_offset :
APPEND_OFFSET_BITS;
+                                       __s32 append_res : APPEND_RES_BITS;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+                                       __s32 append_res : APPEND_RES_BITS;
+                                       __u64 append_offset :
APPEND_OFFSET_BITS;
+#endif
+                               }__attribute__ ((__packed__));
+                       };
+                };
+        };
 };

-- 
Joshi
