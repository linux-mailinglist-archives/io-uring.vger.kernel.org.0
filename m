Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9D69265B
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjBJTaQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbjBJTaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:30:01 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF8B7D8BD;
        Fri, 10 Feb 2023 11:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=sdohRzqa5d1KLw/5QlsnlVMZyzj35/qmiKMTCHFuH20=; b=HcdiNnpTWGBgIXzMc4dlptDa9r
        gsriTjRTC8qzHAliSS/bYM/Y68q/ZzYPhjn/D9AHo1aSZhb8utKqTxVIIU5AJ9IDHhc8EKO2T1jfP
        gf49dCAvreG5hYSri4VdX35lRB4sba8riVLZYQPdWilPuBcylZkI0yDJmr64C4/o/QngrQe/Ua+RB
        Xmt0hxeyZjH43pu7MxIZHQ8xhmWZKkt7tgvL1bhfpFTmV8joetZC1mwiF+/45UIfZV09u5KmQszeC
        ZXIEPqeDOt302HrExWji+LR3ZyWLifhUfUmKv9JacDrMumMNhVHllXdv1nit3fusB1o8KzmylEldl
        rlVFuVtCtgXRCUnQCr3VSJzsdzWNZSuOWY6SwEdCB/M84mvJS0ZJcq8wSN5f7qPRQq/tOf+4QPsHS
        tL0aUjbK4AVIxLxlUQsx4HTayxk6BOPBk+JJA1Od2MuWrVgR1Ks87cmKlmBBDERlBi3+iroDo0Y4x
        d/D2vW8XU7KpWsF0CdL+yqmW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pQZ5p-00D3LZ-QD; Fri, 10 Feb 2023 19:29:57 +0000
Message-ID: <c3f166d3-35b6-25cf-6ccb-8650e90a5a17@samba.org>
Date:   Fri, 10 Feb 2023 20:29:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>, Andy Lutomirski <luto@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wj8rthcQ9gQbvkMzeFt0iymq+CuOzmidx3Pm29Lg+W0gg@mail.gmail.com>
 <20230210021603.GA2825702@dread.disaster.area>
 <20230210040626.GB2825702@dread.disaster.area>
 <Y+XLuYh+kC+4wTRi@casper.infradead.org>
 <20230210065747.GD2825702@dread.disaster.area>
 <CALCETrWjJisipSJA7tPu+h6B2gs3m+g0yPhZ4z+Atod+WOMkZg@mail.gmail.com>
 <CAHk-=wj66F6CdJUAAjqigXMBy7gHquFMzPNAwKCgkrb2mF6U7w@mail.gmail.com>
 <CALCETrU-9Wcb_zCsVWr24V=uCA0+c6x359UkJBOBgkbq+UHAMA@mail.gmail.com>
 <Y+aKuC1PuvX4STEI@jeremy-acer>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Y+aKuC1PuvX4STEI@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 10.02.23 um 19:19 schrieb Jeremy Allison:
> On Fri, Feb 10, 2023 at 09:57:20AM -0800, Andy Lutomirski via samba-technical wrote:
>>
>> (And if Samba needs to make sure that future writes don't change the
>> outgoing data even two seconds later when the data has been sent but
>> not acked, then maybe a fancy API could be added to help, or maybe
>> Samba shouldn't be using zero copy IO in the first place!)
> 
> Samba doesn't need any of this. The simplest thing to do is
> to restrict splice-based zero-copy IO to files leased by
> a single client, where exclusive access to changes is controled
> by the client redirector.

Yes, I guess we can use it if the file is read-only (from it's acls),
or when the client has a read lease. And of course we can have an I don't care
option, maybe reusing 'use sendfile = yes' as that has the same problem in
the existing code already.

metze
