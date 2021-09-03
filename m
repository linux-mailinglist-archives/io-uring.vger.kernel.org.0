Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31F14006BC
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 22:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhICUji (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 16:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbhICUjd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 16:39:33 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD0C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 13:38:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m26so427701pff.3
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 13:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SXA74MGGnpMLJBlBLFB2fo0p77PdPKeB7j4vWOpFbgA=;
        b=nw2VJup3MuIT3HYBDrxKERcfiBaDohh+oGekw2GnKIB3/5yL7SZsrrGJ+uxDCbsprl
         yArFwNdaf5aDJuBQ/5yveze8lPGExml2Y3ATqAD4i4H4u/AXXFJMnxw4ecUWgXc4b9aS
         k/YxZZW9iVXFN3LCyJutIc1C5PZKafRX/Oj1q6/d0cFSK0F5HvSdOrPg2b9EsSU+gr40
         BzOavNjXQMy8QmLjzMG/9+EeKPOzm3IAWSdFWLY5aSCQec3tJcsJOgB+n8lizV4t+vNU
         TUdREwSHFa7EXMo+dylFlSX8KumY2JrRowHRkTfH78sEY8jS89x1jd6cvOqqfR6TVTlo
         If6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SXA74MGGnpMLJBlBLFB2fo0p77PdPKeB7j4vWOpFbgA=;
        b=kFTpb/9jtWAWVodapdiFJMKaB3ok+2827WIjOClFK/9Vn2r8dbOWHIp4UXma9v4uD5
         UIVb0jBuRvLjQrzJweMCmdS6BoxkV9RWw5OJi4Q1lRDYAgbeyv+klKsJXkootwOYxl6n
         yzJZgV9NzWE/6i7Xnl0rvDmPAGitKpZKWE1xib0cZEYi7fqJNV7JThyv2vMRU0DjHD3J
         cjGp53k4TiqeRHLX5fZtyxVB41GMUENGYoB3blORr2jfZfXdOUwqffPmJw30lhebVCT+
         PplQcUISGgg8dvg6ruj7ugVf/FEvQ40afc2Tew+5U1BTAwu9tsNXjbSbnl4HFNgCUBV8
         2SDw==
X-Gm-Message-State: AOAM530SKqkau/usppnfN1ARk0KkKpNeb7uNvqU3lWbIIGhLJk5Et1Eg
        xo5Mm4fawm9Fzmi3B7W5Jf8yoA==
X-Google-Smtp-Source: ABdhPJweoVMMzL7tuqAQdffveXdXyK8C4wFxqZl/wW2SRRGmxbgZ8vmT7er7geuhYIAzmGP+N28/MA==
X-Received: by 2002:a05:6a00:16d2:b029:300:200b:6572 with SMTP id l18-20020a056a0016d2b0290300200b6572mr703225pfc.62.1630701511522;
        Fri, 03 Sep 2021 13:38:31 -0700 (PDT)
Received: from ?IPv6:2600:380:7567:4da9:ea68:953f:1224:2896? ([2600:380:7567:4da9:ea68:953f:1224:2896])
        by smtp.gmail.com with ESMTPSA id w17sm238691pfq.111.2021.09.03.13.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:38:31 -0700 (PDT)
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 kiocb_done
To:     syzbot <syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000000d4da305cb1d2467@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5a93ff90-98be-b5af-29e9-a2f8cca82458@kernel.dk>
Date:   Fri, 3 Sep 2021 14:38:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000000d4da305cb1d2467@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 2:28 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4ac6d90867a4 Merge tag 'docs-5.15' of git://git.lwn.net/li..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13a275f5300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3c3a5498e99259cf
> dashboard link: https://syzkaller.appspot.com/bug?extid=726f2ce6dbbf2ad8d133
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124a3b49300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142e610b300000

#syz test git://git.kernel.dk/linux-block for-5.15/io_uring

-- 
Jens Axboe

