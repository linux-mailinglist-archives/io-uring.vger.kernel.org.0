Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D96F5EFB60
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 18:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiI2QyP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 12:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiI2QyP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 12:54:15 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9121CDB62
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 09:54:12 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id j7so994083ilu.7
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 09:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=17i72a+YF0QmIvoa5dXmyWylrfLAdgH3Jl0OS8NotoI=;
        b=Zw/TDh2RKXoZlSdAe2DwIirm3QH3vBvDhtE5sN15EpwqSD+90Z/Z5CwndYmNGbK4UR
         BRqyAgKn/IxtKRKRbBzJ+pZMgV5wAkl3/uzAQdcAfJm6JyQMrMKtPW0vDZAGGAUllu4j
         G7My10L+c2J2GzOz5sUGom2gOpJco+ir4FA79eRdDJSco5rQ78UScxnB8IcdT7HgeTWB
         RvuqlYbvoiOSeA2Hz2gEdrzZqur8VeDTcFL+hQyMQXNYRuil8+o2aez1RR2BNeN5m9ZW
         9szAbu2jXsjV2+IM6wtbVzmpE1rqOReuvrh8zy3WqLhRxsOwy86dsq8ItK0UxdDMiH8L
         fvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=17i72a+YF0QmIvoa5dXmyWylrfLAdgH3Jl0OS8NotoI=;
        b=rU4jO8JZFb11k14rLiqpahADc6oYRK9xwfNXDZFCwVeLJ/U23bzmQD0T1JX19eDxx4
         lEivWu4wdIfS1ELDTppCVF2iIFj3F8iefkJzxzB5JjtNlc1P+Jee5bBgZy7/ek+qKXP0
         hCJodsWJmS6M9AqEH7o6El72Q17p1QVWnP/7WPC8ioUehqnTYURyY7wCjBXn3nHFpmwF
         jdpV5ZSczno/kPbMvY8CAJL6WUdD6rWua2D6AkuGrk6leCwZT4+BWDBYIJCCaH/CQlmX
         XAzBN1TH7HMcMn9TKZfdrBUhkDoGxzYqsjFj2bMS9EgR2TChqwrsz5O0Zil/pYMVcVvB
         Nu+g==
X-Gm-Message-State: ACrzQf0GOS7o58XiRX877V1EUVoKZXeNkWfo9/y2pDBd0ISf5GKRq1He
        X7jn42fw/hzvUMXYsHSG4GM7tA==
X-Google-Smtp-Source: AMsMyM5eKw23leYHbcb6R8MlnLurdMWO/9Ca4vA3JgEmNWoOg/E6eIk/sdLUztIX2+j+HyTMzG0b1A==
X-Received: by 2002:a05:6e02:184f:b0:2f6:9356:6cf5 with SMTP id b15-20020a056e02184f00b002f693566cf5mr2111438ilv.112.1664470451301;
        Thu, 29 Sep 2022 09:54:11 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n29-20020a02a19d000000b00346b4b25252sm3072596jah.13.2022.09.29.09.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 09:54:10 -0700 (PDT)
Message-ID: <77a66454-8d18-6a92-803b-76273ec998eb@kernel.dk>
Date:   Thu, 29 Sep 2022 10:54:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [syzbot] inconsistent lock state in kmem_cache_alloc
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>
Cc:     syzbot <syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        mhiramat@kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Matthew Bobrowski <repnop@google.com>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
References: <00000000000074b50005e997178a@google.com>
 <edef9f69-4b29-4c00-8c1a-67c4b8f36af0@suse.cz>
 <20220929135627.ykivmdks2w5vzrwg@quack3>
 <0f7a2712-5252-260c-3b0f-ec584e1066a3@kernel.dk>
In-Reply-To: <0f7a2712-5252-260c-3b0f-ec584e1066a3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/22 8:07 AM, Jens Axboe wrote:
> On 9/29/22 7:56 AM, Jan Kara wrote:
>> On Thu 29-09-22 15:24:22, Vlastimil Babka wrote:
>>> On 9/26/22 18:33, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    105a36f3694e Merge tag 'kbuild-fixes-v6.0-3' of git://git...
>>>> git tree:       upstream
>>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=152bf540880000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7db7ad17eb14cb7
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=dfcc5f4da15868df7d4d
>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1020566c880000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104819e4880000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com
>>>
>>> +CC more folks
>>>
>>> I'm not fully sure what this report means but I assume it's because there's
>>> a GFP_KERNEL kmalloc() allocation from softirq context? Should it perhaps
>>> use memalloc_nofs_save() at some well defined point?
>>
>> Thanks for the CC. The problem really is that io_uring is calling into
>> fsnotify_access() from softirq context. That isn't going to work. The
>> allocation is just a tip of the iceberg. Fsnotify simply does not expect to
>> be called from softirq context. All the dcache locks are not IRQ safe, it
>> can even obtain some sleeping locks and call to userspace if there are
>> suitable watches set up.
>>
>> So either io_uring needs to postpone fsnotify calls to a workqueue or we
>> need a way for io_uring code to tell iomap dio code that the completion
>> needs to always happen from a workqueue (as it currently does for writes).
>> Jens?
> 
> Something like this should probably work - I'll write a test case and
> vet it.

Ran that with the attached test case, triggers it before but not with
the patch. Side note - I do wish that the syzbot reproducers were not
x86 specific, I always have to go and edit them for arm64. For this
particular one, I just gave up and wrote one myself.

Thanks for the heads-up Jan, I'll queue up this fix and mark for stable
with the right attributions.

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/fanotify.h>
#include <sys/wait.h>
#include <liburing.h>

int main(int argc, char *argv[])
{
	struct io_uring_sqe *sqe;
	struct io_uring_cqe *cqe;
	struct io_uring ring;
	int fan, ret, fd;
	void *buf;

	fan = fanotify_init(FAN_CLASS_NOTIF|FAN_CLASS_CONTENT, 0);
	if (fan < 0) {
		if (errno == ENOSYS)
			return 0;
		perror("fanotify_init");
		return 1;
	}

	if (argc > 1) {
		fd = open(argv[1], O_RDONLY | O_DIRECT);
		if (fd < 0) {
			perror("open");
			return 1;
		}
	} else {
		fd = open("file0", O_RDONLY | O_DIRECT);
		if (fd < 0) {
			perror("open");
			return 1;
		}
	}

	ret = fanotify_mark(fan, FAN_MARK_ADD, FAN_ACCESS|FAN_MODIFY, fd, NULL);
	if (ret < 0) {
		perror("fanotify_mark");
		return 1;
	}

	ret = 0;
	if (fork()) {
		int wstat;

		io_uring_queue_init(4, &ring, 0);
		if (posix_memalign(&buf, 4096, 4096))
			return 0;
		sqe = io_uring_get_sqe(&ring);
		io_uring_prep_read(sqe, fd, buf, 4096, 0);
		io_uring_submit(&ring);
		ret = io_uring_wait_cqe(&ring, &cqe);
		if (ret) {
			fprintf(stderr, "wait_ret=%d\n", ret);
			return 1;
		}
		wait(&wstat);
		ret = WEXITSTATUS(wstat);
	} else {
		struct fanotify_event_metadata m;
		int fret;

		fret = read(fan, &m, sizeof(m));
		if (fret < 0)
			perror("fanotify read");
		/* fail if mask isn't right or pid indicates non-task context */
		else if (!(m.mask & 1) || !m.pid)
			exit(1);
		exit(0);
	}

	return ret;
}

-- 
Jens Axboe
