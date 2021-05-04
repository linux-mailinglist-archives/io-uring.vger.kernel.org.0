Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99D3372B01
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhEDN3K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 09:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhEDN3K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 09:29:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D16C061574;
        Tue,  4 May 2021 06:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=hVi4JKdpd7bTk4RdXZOXhzQdF+xeih0pHyzet/IpH4o=; b=GkMcUwUogomY0TC0mlYd1YN62g
        Tfam9DJKtm/UEB3fVvkCaXuyJmPaqyjdZWrLhEd5Crb4Xt95uQCrl2bybCmnbuFI884PKjmCtvNlm
        uuPBBXP+uPBEFoDPrlC7Mj/6m/C/C2Fy1VxErtWmW9r0HAOHs4JPOBX9JkiiukYDdV/CjyZfrNxVW
        F4FKn+B9+zkjcMlqei6Z8aAbxF5bJ1fl3BcfFtJoX5ekNe10VwX3wh82iSoKb7ifJV2DwQUpwISd2
        W7XStoB2k4sDK0G5eB09dB3DRb1siqs7qIoBwXVMNxJduwQyfQEqE5dP9KQSbfv6ZZEQlHrKwEw2u
        P2d7Vczi1wspNlZ9YOiJlDvsvZUiqQxrRqNapLJgQ19SY5gCxgTdGdgFv2Q5hdOxnhRyjg6UchEl1
        uN92nsAGAVo+sO7jZJmiDsrUmDLDomTdxgR0QnRBsvIxpTBaFJA7vNR1mLvgF1rXh8LD3XPwhVhNW
        8Hqg+up3IvOistlVxMBDq7wa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1ldv5x-00063w-4B; Tue, 04 May 2021 13:28:13 +0000
Subject: Re: Tracing busy processes/threads freezes/stalls the whole machine
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, linux-trace-devel@vger.kernel.org,
        io-uring <io-uring@vger.kernel.org>
References: <293cfb1d-8a53-21e1-83c1-cdb6e2f32c65@samba.org>
 <20210504092404.6b12aba4@gandalf.local.home>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <f590b26d-c027-cc5a-bcbd-1dc734f72e7e@samba.org>
Date:   Tue, 4 May 2021 15:28:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210504092404.6b12aba4@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 04.05.21 um 15:24 schrieb Steven Rostedt:
> On Thu, 22 Apr 2021 16:26:57 +0200
> Stefan Metzmacher <metze@samba.org> wrote:
> 
>> Hi Steven, hi Ingo,
>>
> 
> Sorry, somehow I missed this.
> 
>> # But
>> # trace-cmd record -e all -P 7
> 
> I'm curious. 
> 
> What is the clock set to? What does:
> 
>  # trace-cmd list -C
> 
> show?

On both machine (physical and VM):
trace-cmd list -C
[local] global counter uptime perf mono mono_raw boot x86-tsc

Thanks for looking at it!
metze
