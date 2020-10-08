Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872D428769A
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgJHPCB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbgJHPCB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:02:01 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D558C0613D3
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 08:02:01 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j13so2049668ilc.4
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=P6w4xCafRHbwrlFfPz4fGd6pUBvY7sGVwZN8EowUQ9E=;
        b=ZkHIYFq4AG21UWWnea6lir2iqx9wcCge82U1rfSPA5awUvOZgjJcZsASTlzI9xcdb7
         V2uqZ6iC/X3/Bh55wKjBUTQjaywr/t+yzb0//LbgL8qqeuZwgHN5mQAE6dpICI0KOE8R
         0ahsq5LhagcyJt0u93o+5QFTuJrC67rYibr02TBLeOncD4tyPY2zGpKabFPf5bIDf9Ia
         wu+LD3bbrAbntvTm8sgAgojmGxL7uK3PuxYJ1FjI+wndPgVUrI6qtpQV3cD5VmlLrhVc
         e3gb2SBDuPARcuv4x96AViEYKnIZV6rxhVZgvicEWLzSRZ200/f62Eny16A9uJIa1xTu
         jEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P6w4xCafRHbwrlFfPz4fGd6pUBvY7sGVwZN8EowUQ9E=;
        b=D6YJMjD9ktv2BaHE/KJ2E5ZFDSgNOtxxIbykylj66iXUzGSJBizzhApuTrWDI4T68A
         mvk1L0r06q07DQyeV8cYe0mk03ma+4eSXR/GKMKZ09RIQ4kHCDOUVl8n2oQbc3J06bKY
         P2L6uoOQKXBgpl12kerbljJ94ZxtkZ6KYrZbwLw+Bu7/cqKq0NiUsP1b15E657UfkHAw
         PqZ2WaWYuWoNe6wMq9jlB0ZCEJ+dysAivf3aFDfFJlSE8adJ7hlslm/3bhZ+5wjR7hoS
         drTt4mIDZGB2h2LRddk6pad6ljKMZl0duZgkvD4ySGZi4m6PYi7IjP+xr9ViuOdTRd85
         HHjQ==
X-Gm-Message-State: AOAM531ysZyDlA5/+d2860biJ+HHKZvJI0Yx0KzYMI6eDRTI+yPHm2+g
        IhT1U4I81YpnodAU1ZzpaWAKg5YB9PYWTA==
X-Google-Smtp-Source: ABdhPJzXGC7Cqlfzu8AjaNIu8ag7EKbF/T2OerPsLkd8v2og61MLo0ACGD6F+TlfZU3nfSOiwG2roQ==
X-Received: by 2002:a92:c74c:: with SMTP id y12mr7242718ilp.19.1602169318868;
        Thu, 08 Oct 2020 08:01:58 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h14sm2760890ilc.38.2020.10.08.08.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 08:01:58 -0700 (PDT)
Subject: Re: inconsistent lock state in xa_destroy
To:     syzbot <syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000045ac4605b12a1720@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de842e7f-fa50-193b-b1d7-c573e515ef8b@kernel.dk>
Date:   Thu, 8 Oct 2020 09:01:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000045ac4605b12a1720@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 9:00 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12555227900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
> dashboard link: https://syzkaller.appspot.com/bug?extid=cdcbdc0bd42e559b52b9
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com

Already pushed out a fix for this, it's really an xarray issue where it just
assumes that destroy can irq grab the lock.

#syz fix: io_uring: no need to call xa_destroy() on empty xarray

-- 
Jens Axboe

