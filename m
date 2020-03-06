Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3774B17C109
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 15:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgCFO5L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 09:57:11 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:36972 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCFO5L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Mar 2020 09:57:11 -0500
Received: by mail-il1-f196.google.com with SMTP id a6so2293918ilc.4
        for <io-uring@vger.kernel.org>; Fri, 06 Mar 2020 06:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mOBDoHnwRUB6vwJ5ZeCRAwk2NHenQL0R+1AwgPwm1qE=;
        b=HXHhLtM7yadtcuawGuR/OolVcyzzUwR6+kgjtly2wv0V5luD4vNO0QpleQk5Dk5XOb
         fdz9J2+kig02fdSVirJqAp18bp6KUZd9c7P+RAb8Gqwwrw3/BegJs72qOSJcbWYcMDn2
         e5Z3azZNgU/Akp1RU13aiVdZco/PDOn1Z/wChXDaUH+IKsgnJmC0EsptUgkj5bLRWVHq
         F0r6MkykcfjX3gImtb+R3n8BOPkWtnaAZ3j4NQPOEhOE8fLIGsmxcKLjt4nR/jSR+sTX
         xNBd+/XhD2lJ/7pZb8+DI5G2ZtpbNN3J10BRKg5xdPBGAh7MX1ohE0y5nboGn67j/r06
         5MQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mOBDoHnwRUB6vwJ5ZeCRAwk2NHenQL0R+1AwgPwm1qE=;
        b=sXfdk4+dKfriptgK0yLM9civBe6/GJ1YnE7JL94HTReTaqAJ3Z+yAeJZNkfj4RIqEL
         oYLotiBqXT3o+Q+oHLmnl+DCwNlJPrveBWFcpZM9bd4n1tf5415wyG/IilU2SlryY9J7
         sX3lw3xX1GXgMp+41jnWeOw5z8IHpnVE5xhMJXnS55/FD/HrAllJ93CmuQ66sArSwAGo
         pKn6sCxs4Ab+h8cbMrmjARAfZiq7Sxtjr/Fmk7VdHUQqxiiYdEPcT+IMHNLHHiJEV5PD
         +t2bZtl2WW00F8y26C9MQFaaJk99nBFb0pG3nNS8aQGwQuJNWoJH2t9mZ14dv0lCSCyp
         clYA==
X-Gm-Message-State: ANhLgQ1Hv1KPkh1cworYzXT7N6ubyxU5PW7o5FvlhUTxCTf3Mzg3d3xr
        ZaoWUOzO/IL5n6DA1s6GWrB4Qw==
X-Google-Smtp-Source: ADFU+vsb0EQMaZ5kM8m27eRB9mgYotBgbREMPaoSXXxO9J3hPpn3+mi0MHsuNlsVAhCgEZAhSU0zqA==
X-Received: by 2002:a92:9603:: with SMTP id g3mr3712133ilh.231.1583506630398;
        Fri, 06 Mar 2020 06:57:10 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d70sm133312ill.11.2020.03.06.06.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 06:57:09 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        the arch/x86 maintainers <x86@kernel.org>
References: <00000000000067c6df059df7f9f5@google.com>
 <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
 <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk>
 <20200306143552.GC19839@kadam>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b816920b-a211-80c0-ceca-f716954b9f96@kernel.dk>
Date:   Fri, 6 Mar 2020 07:57:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200306143552.GC19839@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/20 7:35 AM, Dan Carpenter wrote:
> 
> There a bunch of similar bugs.  It's seems a common anti-pattern.
> 
> block/blk-cgroup.c:85 blkg_free() warn: freeing 'blkg' which has percpu_ref_exit()
> block/blk-core.c:558 blk_alloc_queue_node() warn: freeing 'q' which has percpu_ref_exit()
> drivers/md/md.c:5528 md_free() warn: freeing 'mddev' which has percpu_ref_exit()
> drivers/target/target_core_transport.c:583 transport_free_session() warn: freeing 'se_sess' which has percpu_ref_exit()
> fs/aio.c:592 free_ioctx() warn: freeing 'ctx' which has percpu_ref_exit()
> fs/aio.c:806 ioctx_alloc() warn: freeing 'ctx' which has percpu_ref_exit()
> fs/io_uring.c:6115 io_sqe_files_unregister() warn: freeing 'data' which has percpu_ref_exit()
> fs/io_uring.c:6431 io_sqe_files_register() warn: freeing 'ctx->file_data' which has percpu_ref_exit()
> fs/io_uring.c:7134 io_ring_ctx_free() warn: freeing 'ctx' which has percpu_ref_exit()
> kernel/cgroup/cgroup.c:4948 css_free_rwork_fn() warn: freeing 'css' which has percpu_ref_exit()
> mm/backing-dev.c:615 cgwb_create() warn: freeing 'wb' which has percpu_ref_exit()

The file table io_uring issue is using the ref in a funky way, switching
in and out of atomic if we need to quiesce it. That's different from
other use cases, that just use it as a "normal" reference. Hence for the
funky use case, you can potentially have a switch in progress when you
exit the ref. You really want to wait for that, the easiest solution is
to punt the exit + free to an RCU callback, if there's nothing else you
need to handle once the switch is done.

So I would not be so quick to assume that similar patterns (exit + free)
have similar issues.

-- 
Jens Axboe

