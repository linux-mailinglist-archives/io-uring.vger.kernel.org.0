Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA3F6E5124
	for <lists+io-uring@lfdr.de>; Mon, 17 Apr 2023 21:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjDQTqE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Apr 2023 15:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjDQTqD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Apr 2023 15:46:03 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECCED2;
        Mon, 17 Apr 2023 12:46:00 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r15so4825331wmo.1;
        Mon, 17 Apr 2023 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681760759; x=1684352759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZkpPzDKNye1p0Bi+afxT2w5cRXkVMuat6OESCAZjOlc=;
        b=eveHTvGUwIurwIcZKUmMfKipRZuwNBExVEK2kdyUYD0mnRERq6S3CwOETEFUtNJQQq
         Pk2wet28Bgynh2pkDhehnVB5XyZV+DnbnPCAyUVzlk8I19H05Ql0ddI/t6QR3SxVfIU0
         zMr5yTp0l0m0AgWqmorrSokbryOwFZ/Fq9htulGq4Qn7fv97hO5keJ8tbBf7OYrdE9k4
         /PBIifCiGixNUFRM1Gf0WHm76UVfb4lp1X1rLzkPHsboYi2+Un59c1ALyX3kylx/9qLv
         zhOzHSKCrCHv7bNKUOiOyUQ+KFpbE+k8xA//HfyiaRWJD8sXvKS9oYa+hYwtUxchU+rS
         Oo2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681760759; x=1684352759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZkpPzDKNye1p0Bi+afxT2w5cRXkVMuat6OESCAZjOlc=;
        b=YmeY97ITTvQI6LzegkOtd5xpBhl5YJ4e8oqpf8bZS/iPyC8VzFwcRBqqgrOf2RBV8A
         pEa3FJ5vn775QfjA/yTD4n+87yTJNhzhmogPGw9mgrxa7g3QxKO9OCZX1JDEun8Y0dRH
         yfctB5lxo5p5bPR75pCgAFZ4ZmoW5DEtuMzGTqH0/3V3C6W8pHz8i7o5ze2noQFOnhph
         /ZxDUWZVZ/Iu7ZdufoSu2oAy6azn06dRt/wWsLqnpiLjOSj84CuLi7nHkCkR9PSrC43X
         Fy7xNHnuYy0uPrs9SvA8xdxwOGpMOC7zkA42J1pmX7Ah2XXCKeUSEUkN1wGqVYKx16LF
         4AzQ==
X-Gm-Message-State: AAQBX9cwPyCCGGD9Ga5gGeAa70BfpXE44lvzJ2VCZ2AIGvbLlbnNUiMb
        HyNrjL+jRsQkiIl5NyxHytukkKfTFRuipA==
X-Google-Smtp-Source: AKy350YDgkjLDIWkKtzJAjyjc2v/ajp+V10odWq38ZQIndOmbKq5H3vd95BsZsLjPRBK6X0UuwLjtA==
X-Received: by 2002:a05:600c:22cf:b0:3ef:5940:5f45 with SMTP id 15-20020a05600c22cf00b003ef59405f45mr10682246wmg.23.1681760759266;
        Mon, 17 Apr 2023 12:45:59 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm5598569wmq.30.2023.04.17.12.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:45:58 -0700 (PDT)
Date:   Mon, 17 Apr 2023 20:45:57 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Message-ID: <dc35e6fb-bf83-4e5a-8938-05d59382691a@lucifer.local>
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <b1f125c8-05ec-4b41-9b3d-165bf7694e5a@lucifer.local>
 <ZD1I8XlSBIYET9A+@nvidia.com>
 <b661ca21-b436-44cf-b70d-0b126989ab33@lucifer.local>
 <ZD2c1CB4FmUVuMln@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD2c1CB4FmUVuMln@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 17, 2023 at 04:24:04PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 17, 2023 at 08:00:48PM +0100, Lorenzo Stoakes wrote:
>
> > So I don't think this route is plausible unless you were thinking of
> > somehow offloading to a thread?
>
> ah, fair enough
>
> > In any case, if we institute the FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag we
> > can just drop FOLL_ANON altogether right, as this will be implied and
> > hugetlb should work here too?
>
> Well.. no, as I said read-only access to the pages works fine, so GUP
> should not block that. It is only write that has issues
>
> > Separately, I find the semantics of access_remote_vm() kind of weird, and
> > with a possible mmap_lock-free future it does make me wonder whether
> > something better could be done there.
>
> Yes, it is very weird, kthread_use_mm is much nicer.
>
> > (Section where I sound like I might be going mad) Perhaps having some means
> > of context switching into the kernel portion of the remote process as if
> > were a system call or soft interrupt handler and having that actually do
> > the uaccess operation could be useful here?
>
> This is the kthread_use_mm() approach, that is basically what it
> does. You are suggesting to extend it to kthreads that already have a
> process attached...

Yeah, I wonder how plausible this is as we could in theory simply eliminate
these remote cases altogether which could be relatively efficient if we
could find a way to batch up operations.

>
> access_remote_vm is basically copy_to/from_user built using kmap and
> GUP.
>
> even a simple step of localizing FOLL_ANON to __access_remote_vm,
> since it must have the VMA nyhow, would be an improvement.

This is used from places where this flag might not be set though,
e.g. acess_process_vm() and ptrace.

However, access_remote_vm() is only used by the proc stuff, so I will spin
up a patch to move this function and treat it as a helper which sets
FOLL_ANON.

>
> Jason
