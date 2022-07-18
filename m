Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7C5783F0
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 15:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiGRNlV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 09:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbiGRNlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 09:41:20 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FA21EC50
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:41:19 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.110.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 9057E7E328;
        Mon, 18 Jul 2022 13:41:17 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658151679;
        bh=MpEUlRmrx0rJtDvqCooB9UYzcBX7S9F9+qotextINx0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ISE0IOJ3goRB7NUBATVnsxVvcwfqyyyJ5dNkJ6wA0waY8bXVqVkoRlqql2JowlouC
         vcr7HUbuYKRsQnyQ4e111zPmT1zIZ7qat+6OLlp9KbsYxMVHcPxzvnIWBfCGZIhfil
         r2bMljvHJ+qo31wd+YV+9CakVwMiqyP9HBBscTJELzFu0WBVed/R8hMnVtLt2VJVhu
         CvQ8W5F3TYY8XVfY0J1Xi8NUIjaIsMqxmvEK8Epkoq5jX5pYfsDOUoCw69/1RDLnOv
         q7JCczOvW4YJbrX94ccHv6ErvNuQyHNhp0x9g6cnXojkKjLn07mhQOvJAHkrBKMhOB
         YlYKAW/j+E7WA==
Message-ID: <accaa2d6-53d6-c45c-28ba-6436652d51ca@gnuweeb.org>
Date:   Mon, 18 Jul 2022 20:41:04 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing] fix io_uring_recvmsg_cmsg_nexthdr logic
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
References: <20220718133429.726628-1-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220718133429.726628-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/22 8:34 PM, Dylan Yudaken wrote:
> io_uring_recvmsg_cmsg_nexthdr was using the payload to delineate the end
> of the cmsg list, but really it needs to use whatever was returned by the
> kernel.
> 
> Reported-by: Jens Axboe <axboe@kernel.dk>
> Fixes: 874406f ("add multishot recvmsg API")
> Signed-off-by: Dylan Yudaken <dylany@fb.com>

The Fixes tag must be at least 12 chars.

-- 
Ammar Faizi


