Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1B7CFDED
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346310AbjJSPdL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 11:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346303AbjJSPdK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 11:33:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5849C132;
        Thu, 19 Oct 2023 08:33:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E6CC433CA;
        Thu, 19 Oct 2023 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697729588;
        bh=Uc+05bAqsoGMggBrKojmgxhn9M02KPabo337XfIvTck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rAaNmsxhMInS/iWv20j3xWfY0Mz+qGbenqq7UF0DBHFFo0BbN17LuuLyqEfZYBJX+
         PjhEpxxA7ivr6e8VtUTSpENbtptf+mwOxVU7bm02JbZiA65dzKm44YZF7tBD6Rk7tE
         yhxccGMxkv9j0p1HlNqM1b9VrG0teaHA/DHPnFX7fyS+MhdJl53Otq0xfOYGQTeKDf
         BoucEdEuKrstivjxTRqIEbyolQvwUJAGvu5BTxK4Bi0u0AZFq1P64ek8gCkFSP3z5c
         d7OsWvtO3RhpEg2lHxAU3Kb9m7GmAVxAWjJd3agnIwsjIjltujvDGhZIyJMJm5Ixmh
         EFwIBhfeubtVA==
Date:   Thu, 19 Oct 2023 08:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Breno Leitao <leitao@debian.org>, sdf@google.com,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v7 00/11] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <20231019083305.6d309f82@kernel.org>
In-Reply-To: <7bb74d5a-ebde-42fe-abec-5274982ce930@kernel.dk>
References: <20231016134750.1381153-1-leitao@debian.org>
        <7bb74d5a-ebde-42fe-abec-5274982ce930@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 19 Oct 2023 08:58:59 -0600 Jens Axboe wrote:
> On 10/16/23 7:47 AM, Breno Leitao wrote:
> > This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
> > and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
> > SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all levels
> > and optnames. SOCKET_URING_OP_GETSOCKOPT is limited, for now, to
> > SOL_SOCKET level, which seems to be the most common level parameter for
> > get/setsockopt(2).
> > 
> > In order to keep the implementation (and tests) simple, some refactors
> > were done prior to the changes, as follows:  
> 
> Looks like folks are mostly happy with this now, so the next question is
> how to stage it?

Would be good to get acks from BPF folks but AFAICT first four patches
apply cleanly for us now. If they apply cleanly for you I reckon you
can take them directly with io-uring. It's -rc7 time, with a bit of
luck we'll get to the merge window without a conflict.
