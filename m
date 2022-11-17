Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DFD62E620
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 21:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiKQUs7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 15:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbiKQUs5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 15:48:57 -0500
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B2A4E422
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 12:48:56 -0800 (PST)
Received: (qmail 66272 invoked by uid 89); 17 Nov 2022 20:48:55 -0000
Received: from unknown (HELO ?192.168.137.22?) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzMS44MA==) (POLARISLOCAL)  
  by smtp3.emailarray.com with ESMTPS (AES256-GCM-SHA384 encrypted); 17 Nov 2022 20:48:55 -0000
From:   Jonathan Lemon <jlemon@flugsvamp.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v1 05/15] io_uring: mark pages in ifq region with zctap
 information.
Date:   Thu, 17 Nov 2022 12:48:53 -0800
X-Mailer: MailMate (1.14r5918)
Message-ID: <F664D487-6054-479D-B87B-B135B81D1F33@flugsvamp.com>
In-Reply-To: <Y3Sbh7N+IbTv2JJf@infradead.org>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
 <20221108050521.3198458-6-jonathan.lemon@gmail.com>
 <Y3Sbh7N+IbTv2JJf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16 Nov 2022, at 0:12, Christoph Hellwig wrote:

> On Mon, Nov 07, 2022 at 09:05:11PM -0800, Jonathan Lemon wrote:
>> The network stack passes up pages, which must be mapped to
>> zctap device buffers in order to get the reference count and
>> other items.  Mark the page as private, and use the page_private
>> field to record the lookup and ownership information.
>
> Who coordinate ownership of page_private here?  What other parts
> of the kernel could touch these pages?

This may be an issue.  The driver, network stack, and application
all utilize the pages, which have been pinned by io_uring.  If the
pages are passed to another subsystem which wants to use the private
area for its own purposes, there will be a conflict.

There doesn’t seem to be a good way to maintain long term information
in the current page structure.  A resolution for this would be using
an external lookup indexed by the page, or changing the information
passed up in the skb.
—
Jonathan
