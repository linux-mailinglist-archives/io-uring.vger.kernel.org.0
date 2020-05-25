Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D511E12C7
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgEYQfg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 12:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgEYQfg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 12:35:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C59C061A0E;
        Mon, 25 May 2020 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=e814a3EwSDU3bTXSkEJNT6vgHjnf2VYqudoUR9H3+xs=; b=SdktWP6PZa9zrpTlTUji6q0oiy
        4TsCxIy09JUsM/HEmw5WtMl0HOZgepyTMECTkAfIxRGwe1SBftrkD7UNo2bnGl7QM7DRgOnw0aeVH
        +85/Nudmw/nz4nDA0DrJ8GxceNwPcLgPdcGD9FaKLhgfzK8Pu+GBnUSKwaT3F32JehrYBo9FjdQng
        hVAzTqRFhmQAzk4zc9gsWZEjhe1m+Fj9mFXGRtSeicpt1/pLrHSM0j87g7e6rgWlVhycUx+WLVwks
        2rXksbf3s+JRr3YDB3ixW9XHhUbKq/GIoxboPArfvw8LYnonxR+YKcxuYfDutNsz4i36fjuWhNZ4H
        uBoSmPrA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdG4d-0006u7-8a; Mon, 25 May 2020 16:35:35 +0000
Subject: Re: linux-next: Tree for May 25 (fs/io_uring)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring@vger.kernel.org, axboe <axboe@kernel.dk>
References: <20200525224923.41fb5a47@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7fbfc86d-bda1-362b-b682-1a9aefa8560e@infradead.org>
Date:   Mon, 25 May 2020 09:35:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525224923.41fb5a47@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/20 5:49 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200522:
> 


on i386:

../fs/io_uring.c:500:26: error: field ‘wpq’ has incomplete type
  struct wait_page_queue  wpq;
                          ^~~
In file included from ../include/linux/export.h:43:0,
                 from ../include/linux/linkage.h:7,
                 from ../include/linux/kernel.h:8,
                 from ../fs/io_uring.c:42:
../fs/io_uring.c: In function ‘io_async_buf_func’:
../include/linux/kernel.h:1003:51: error: dereferencing pointer to incomplete type ‘struct wait_page_queue’
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                                                   ^
../include/linux/compiler.h:372:9: note: in definition of macro ‘__compiletime_assert’
   if (!(condition))     \
         ^~~~~~~~~
../include/linux/compiler.h:392:2: note: in expansion of macro ‘_compiletime_assert’
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
../include/linux/kernel.h:1003:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
  ^~~~~~~~~~~~~~~~
../include/linux/kernel.h:1003:20: note: in expansion of macro ‘__same_type’
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                    ^~~~~~~~~~~
../fs/io_uring.c:2618:8: note: in expansion of macro ‘container_of’
  wpq = container_of(wait, struct wait_page_queue, wait);
        ^~~~~~~~~~~~
In file included from <command-line>:0:0:
./../include/linux/compiler_types.h:133:35: error: invalid use of undefined type ‘struct wait_page_queue’
 #define __compiler_offsetof(a, b) __builtin_offsetof(a, b)
                                   ^
../include/linux/stddef.h:17:32: note: in expansion of macro ‘__compiler_offsetof’
 #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                ^~~~~~~~~~~~~~~~~~~
../include/linux/kernel.h:1006:21: note: in expansion of macro ‘offsetof’
  ((type *)(__mptr - offsetof(type, member))); })
                     ^~~~~~~~
../fs/io_uring.c:2618:8: note: in expansion of macro ‘container_of’
  wpq = container_of(wait, struct wait_page_queue, wait);
        ^~~~~~~~~~~~
../fs/io_uring.c:2620:8: error: implicit declaration of function ‘wake_page_match’; did you mean ‘huge_page_mask’? [-Werror=implicit-function-declaration]
  ret = wake_page_match(wpq, key);
        ^~~~~~~~~~~~~~~
        huge_page_mask
  AR      sound/pci/ac97/built-in.a
../fs/io_uring.c: In function ‘io_rw_should_retry’:
../fs/io_uring.c:2667:8: error: implicit declaration of function ‘kiocb_wait_page_queue_init’; did you mean ‘pgdat_page_ext_init’? [-Werror=implicit-function-declaration]
  ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
        ^~~~~~~~~~~~~~~~~~~~~~~~~~
        pgdat_page_ext_init


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
