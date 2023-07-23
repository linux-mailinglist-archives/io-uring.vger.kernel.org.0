Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1268675E495
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 21:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjGWTob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 15:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGWToa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 15:44:30 -0400
Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C74C9;
        Sun, 23 Jul 2023 12:44:29 -0700 (PDT)
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.prv.sapience.com (srv8.prv.sapience.com [x.x.x.x])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by s1.sapience.com (Postfix) with ESMTPS id E36F6480A2C;
        Sun, 23 Jul 2023 15:44:28 -0400 (EDT)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1690141468;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=RrAe0WNGCR1n2zOvU84i5qWzyH6QFsoG7N30U7+nsCA=;
 b=vTg+32a4erq+w35WlA3VOP1jwHVfO4iHZDcROFEqP6ak8RNXohNvR0GyB5O2AMkze6Yjf
 QsKxR6VHvKJw6NwAg==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1690141468;
        cv=none; b=O2myukFkkH6nhHwCL0cHnoxaiNoh/j/S/3kZfazli6K4qPtbVsP6I5rA7y7a0ujBlvliIQv4oce4S2Ly+3YCNODySO8Y1JnkuMQS8MLQe4g+XWMGzYiQro5bLvPViaxEkelVd2CyB4Bn734/NzypVg4DfA6Wckw98ZY8aJoaY/ZFBInV0SCoBJnxs+gdTHWthbMLGqad0iQAmGN3g0PTPNkqok4ADgWOPFZJrMdXlzZuC2JvinI5WzgTIpsCQaP5o2uS7WIdIqp1hGP983w8KtKiCJfDqbfIESYnJaS+SNCJE4c5ojnfUhAu7MIBB+Dgyo4jBqrpFl75WdHJtMUBFA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
        t=1690141468; c=relaxed/simple;
        bh=aWQms/qjTalw5kN5DpevHM+wl9NgSm+xYtEpK/8acSU=;
        h=DKIM-Signature:DKIM-Signature:Message-ID:Date:MIME-Version:
         User-Agent:Subject:Content-Language:To:Cc:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding; b=KC2xLMpU+/gnQ7Ga7rMcF2DCUJgy69c0IUMJTXpS8Z69WG/F4gZPtHjBZmBAw124unlgyqKx1wS9uzl1/0S8sKdPD/7juKWEj4gaJgm6qeNZOHJRJhqSMWPbigecEW/5jOXzoh+obAxnahM33q+rt36DFh/k5htcrZQ8U4sYxuDxKxEKHARzZsVECto9HQ2ryonuxLpATEXpOX0X+j4XY4q1dvyqY6NAHrMuQPqYa0qY6m2tLTw3NF/LkrSXl2XqTJyRRiFKGdzSHCHytDLjNqL1ROtueGc6HjqLQvCsjjt7lHXHv0zlEJM/47Qki1Ont2kQzjOorSVnmllE8P58zQ==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1690141468;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=RrAe0WNGCR1n2zOvU84i5qWzyH6QFsoG7N30U7+nsCA=;
 b=mu6pH6DHjupUvBEy6+RvY8govRY3JZyJyZfS9tThRk3GxI0i7igzpTDqzOoBkN9WfA672
 L6g2jluey2mQ4sNK/rbGWHJbbnqjvTRhOTsa3mdmdKTnFNMmw5s4ZkcPWaxuLjtUerW1QzP
 maEv5uJWBN/zTfu32fZW3B4XLYJWmXWcjZYW39Z2EIlblg5hnpZ6xagn9FBEy3D8krn8tT5
 xQaEbT/ziGFihcL334F3bxh3IHvh1cmOODNXhFA4TEtc1GzINAX4CkhmVeX7eTs84GpOuGR
 4nteZpKS9R98j9irCnxxtNg6+4nzgQmoy82nYlqYI/M1g9U9H95cBatHmPUQ==
Message-ID: <0b738504-07af-4e81-2a9f-2b6f3754a2f0@sapience.com>
Date:   Sun, 23 Jul 2023 15:44:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230716194949.099592437@linuxfoundation.org>
 <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
 <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
 <2691683.mvXUDI8C0e@natalenko.name>
 <20230723185856.h6vjipo4rguf6emt@awork3.anarazel.de>
From:   Genes Lists <lists@sapience.com>
In-Reply-To: <20230723185856.h6vjipo4rguf6emt@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/23 14:58, Andres Freund wrote:

> Just to confirm I understand: Your concern is how it looks in mpstat, not
> performance or anything like that?

Right - there is no performance issue or any other issue to my knowledge 
and cores are idle.

So, as you said, its just a small reporting item - which is now quite clear.

thank you.

gene
