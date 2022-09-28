Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9535EDAB1
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 12:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiI1K46 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 06:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiI1K4d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 06:56:33 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5738876AD
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 03:55:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lx7so5333077pjb.0
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 03:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bnoordhuis-nl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uXE3CcDylITePqtvKDDM8O68CJA5Dm1Uy9wTTZKQr3c=;
        b=mSrdZX2VGIK5da4n9Ar9rygPqsmCQ3xEU580wtqpBpwPRYlMipIaHBeTB7jOe6AiOF
         GbyvRvbaofT3Yf15tbAFE9sBxBXPTs3M2Fe6GLO1cAF9spRNV9z1H9sBkAhL01I490Sr
         i/9up4JNe6/01LgmZ80t9UwhQ5/j56wdbh7MllNSvtWsfLoLy657NaBZlHsYoRNrQWuZ
         7OD23NVvknvaLvy4zteTePh9JBGj+1YNRnOaaZOzaCt9WP9dYjEDuURkpKYy/w8PLdxT
         0UMk7zl/3Few9s7BxkLT6CCkPQOIdbLOUGGTniq9iRKp2uNbdYZx4r6IAeLIzWHtp0Jf
         8uBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uXE3CcDylITePqtvKDDM8O68CJA5Dm1Uy9wTTZKQr3c=;
        b=Flo/Rk6RwtXj4BossEYqw7Sp7WK8UdAxDKkk46Z3mFXS320OiBD9iATPRDFDkRPyGm
         XO4cj9SySx2B307mkgl9P0XpcDeeeS89YOuJKi/6pF6O00JUI9WfWyxF+P7zkXT9oe7y
         123RahiG2yhtG/lzt6NcYCkUDoY82WhTHYalxi9j1/BfrHYHEitLVRNshjAycLSS7APZ
         fMsrQUrrlGLFFbD9j653iblxKHOrHMZUTQf95YG2KNt91KBy6NS4HelO7xTs0zJf8Zxt
         TDGc7z+9jnTtNRnjNmgLe/Jjpu2ost98ugXO1+n7QfmNP988eJ7mtTVyGhDzT9CeuHzP
         pGZQ==
X-Gm-Message-State: ACrzQf0VSWfZsvrN1s0GTf68lBE9KLxh4rbJAg/JY/k+4w+XwTwh+Q0O
        rgapclRnrvSG7N0qYz9Tx/1RmPQa3IGYXqefaGY6WA==
X-Google-Smtp-Source: AMsMyM7ngNB657jxH1UepbF8wwB5X7869/BTqcBJXA5zQCVvG52WRxXTlw86QAr+W6bKc+oaLFl/KotPDMshLFXBhTE=
X-Received: by 2002:a17:90b:4a50:b0:203:1204:5bc4 with SMTP id
 lb16-20020a17090b4a5000b0020312045bc4mr9946376pjb.79.1664362520381; Wed, 28
 Sep 2022 03:55:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQurc-0iK9zawpc_k_-wSUVMp_+v14K+t-EJEDXL0pYkzD80A@mail.gmail.com>
 <ff41b5f7-93a5-26ee-bae5-80fc828e1a45@gmail.com>
In-Reply-To: <ff41b5f7-93a5-26ee-bae5-80fc828e1a45@gmail.com>
From:   Ben Noordhuis <info@bnoordhuis.nl>
Date:   Wed, 28 Sep 2022 12:55:08 +0200
Message-ID: <CAHQurc9e=BU3gXbc=brb1b+vLb7nmeyeVaGwqkgRoqnSyHT2AQ@mail.gmail.com>
Subject: Re: Chaining accept+read
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 28, 2022 at 12:02 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 9/28/22 10:50, Ben Noordhuis wrote:
> > I'm trying to chain accept+read but it's not working.
> >
> > My code looks like this:
> >
> >      *sqe1 = (struct io_uring_sqe){
> >        .opcode     = IORING_OP_ACCEPT,
> >        .flags      = IOSQE_IO_LINK,
> >        .fd         = listenfd,
> >        .file_index = 42, // or 42+1
> >      };
> >      *sqe2 = (struct io_uring_sqe){
> >        .opcode     = IORING_OP_READ,
> >        .flags      = IOSQE_FIXED_FILE,
> >        .addr       = (u64) buf,
> >        .len        = len,
> >        .fd         = 42,
> >      };
> >      submit();
> >
> > Both ops fail immediately; accept with -ECANCELED, read with -EBADF,
> > presumably because fixed fd 42 doesn't exist at the time of submission.
> >
> > Would it be possible to support this pattern in io_uring or are there
> > reasons for why things are the way they are?
>
> It should already be supported. And errors look a bit odd, I'd rather
> expect -EBADF or some other for accept and -ECANCELED for the read.
> Do you have a test program / reporoducer? Hopefully in C.

Of course, please see below. Error handling elided for brevity. Hope
I'm not doing anything stupid.

For me it immediately prints this:

0 res=-125
1 res=-9

Some observations:

- it's not included in the test case but I can tell from the user_data
field the -EBADF is the read op
- replacing IORING_OP_READ with e.g. IORING_OP_NOP makes it work
(accepts a connection)
- once the fd has been installed, I can successfully chain
IOSQE_FIXED_FILE read&write ops

I'm primarily testing against a 5.15 kernel. Is this something that's
been fixed since? I went through the commit history but I didn't find
anything relevant.

---

#include <linux/io_uring.h>
#include <netinet/in.h>
#include <stdatomic.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
int main(void) {
  struct sockaddr_in sin = {
    .sin_family = AF_INET,
    .sin_addr   = (struct in_addr){ htonl(INADDR_ANY) },
    .sin_port   = htons(9000),
  };
        int listenfd = socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, 0);
        (void) bind(listenfd, (struct sockaddr *) &sin, sizeof(sin));
  (void) listen(listenfd, 128);
  struct io_uring_params p = {};
  int ringfd = syscall(__NR_io_uring_setup, 32, &p);
  int files[64]; memset(files, -1, sizeof(files));
        syscall(__NR_io_uring_register,
          ringfd, IORING_REGISTER_FILES, files, 64);
  __u8 *sq = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
      PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
      ringfd, IORING_OFF_SQ_RING);
  __u8 *cq = mmap(
      0, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
      PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
      ringfd, IORING_OFF_CQ_RING);
  struct io_uring_sqe *sqe = mmap(0, p.sq_entries * sizeof(*sqe),
      PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE,
      ringfd, IORING_OFF_SQES);
        __u32 *sqtail  = (__u32 *) (sq + p.sq_off.tail);
        __u32 *sqarray = (__u32 *) (sq + p.sq_off.array);
        struct io_uring_cqe *cqe =
      (struct io_uring_cqe *) (cq + p.cq_off.cqes);
  sqe[0] = (struct io_uring_sqe){
    .opcode     = IORING_OP_ACCEPT,
    .flags      = IOSQE_ASYNC|IOSQE_IO_LINK,
    .fd         = listenfd,
    .file_index = 42,
  };
  char buf[256];
  sqe[1] = (struct io_uring_sqe){
    .opcode     = IORING_OP_READ,
    .flags      = IOSQE_FIXED_FILE,
    .fd         = 42,
    .len        = sizeof(buf),
    .addr       = (__u64) buf,
  };
  sqarray[0] = 0; sqarray[1] = 1;
  atomic_store((atomic_uint *) sqtail, 2);
  int n = syscall(__NR_io_uring_enter,
                  ringfd, 2, 1, IORING_ENTER_GETEVENTS, 0, 0);
  for (int i = 0; i < n; i++) printf("%d res=%d\n", i, cqe[i].res);
  return 0;
}
