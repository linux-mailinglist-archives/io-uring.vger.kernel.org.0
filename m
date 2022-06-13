Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78628548EBD
	for <lists+io-uring@lfdr.de>; Mon, 13 Jun 2022 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347541AbiFMMko (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 08:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355235AbiFMMjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 08:39:06 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00C25DD01
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 04:08:44 -0700 (PDT)
Message-ID: <f2fddce1-bc25-183e-6095-bb5a70a57319@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655118523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mf6RwUQeNgkeArC+1b+8sq01ixRB3ZvnZtxt9kdLb5E=;
        b=UMxh6mTptV859adP32Y2n174qKqWpQDWZHODYDCI9x1yaDwstiPgJ+Sfs8rEkeSQsV0GW5
        pU9W8HSjKlEf4aBT5oL4usVp2C3M4ztAiHCaB7+O4zF7XsvuqXYAGHy2KCp0s0WVPpIjw/
        F3JFVeQTpsu1Xt6hgXPmtqMMEaVc4jg=
Date:   Mon, 13 Jun 2022 19:08:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] io_uring: fixes for provided buffer ring
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, axboe@kernel.dk,
        asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220613101157.3687-1-dylany@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20220613101157.3687-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/13/22 18:11, Dylan Yudaken wrote:
> This fixes two problems in the new provided buffer ring feature. One
> is a simple arithmetic bug (I think this came out from a refactor).
> The other is due to type differences between head & tail, which causes
> it to sometimes reuse an old buffer incorrectly.
> 
> Patch 1&2 fix bugs
> Patch 3 limits the size of the ring as it's not
> possible to address more entries with 16 bit head/tail

Reviewed-by: Hao Xu <howeyxu@tencent.com>

> 
> I will send test cases for liburing shortly.
> 
> One question might be if we should change the type of ring_entries
> to uint16_t in struct io_uring_buf_reg?

Why not? 5.19 is just rc2 now. So we can assume there is no users using
it right now I think?


