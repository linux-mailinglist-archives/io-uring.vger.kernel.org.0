Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16128731971
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 15:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbjFONBK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jun 2023 09:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237810AbjFONBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jun 2023 09:01:09 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF04726AF;
        Thu, 15 Jun 2023 06:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1686834062;
        bh=WzSN2v8X+O/rHasI/KyrPKFFu5Qm7v7pcSKlF7ir640=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=nGKhdIRMroziQJmIx3NJbp48M0tEu5ZoEIBdsd4tImxUe7oOnCBcOI6dTzx8yXWSP
         RbhKlU1Ufpva/ajMFGtXx8w6y3228mXLZLJ6ZEXPiK4zkqkkpgCpm9YfnnT4lLaS9b
         2DL5ld/te4qc4cS03mX4myiC0dh0BHtWwybQ5h9QwIf34k0QMy59J057GGg8ZnKVKd
         XiuuhLk7Cy2zYgu6cvy02m0k+RFBf9FiCsfM+K1FO765Mw6B5hIQEK7LAKAzW9vfJq
         Ysr9jh/NeOdPGjIP1sbXQTvdTD2P+wcR0aNShMUiTHgMB9UEDOzYczReEV2fDz7Kvs
         8zx2f4evbWKeQ==
Received: from [10.20.0.2] (unknown [182.253.126.223])
        by gnuweeb.org (Postfix) with ESMTPSA id 9079E249C33;
        Thu, 15 Jun 2023 20:01:00 +0700 (WIB)
Message-ID: <34898926-681e-1790-4303-e2b54e793a62@gnuweeb.org>
Date:   Thu, 15 Jun 2023 20:00:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] tools/io_uring: Fix missing check for return value of
 malloc()
Content-Language: en-US
To:     Chenyuan Mi <cymi20@fudan.edu.cn>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20230615125045.125172-1-cymi20@fudan.edu.cn>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20230615125045.125172-1-cymi20@fudan.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/23 7:50 PM, Chenyuan Mi wrote:
> The malloc() function may return NULL when it fails,
> which may cause null pointer deference in kmalloc(),

It's a userspace app, there is no kmalloc(). Also, I don't think it's
worth to fix a missing ENOMEM handling for that old test program. But
anyway, let's wait for maintainers' comment on this.

-- 
Ammar Faizi

