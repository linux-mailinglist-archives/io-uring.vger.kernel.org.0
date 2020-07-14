Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD51621F7B0
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 18:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgGNQum (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 12:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgGNQul (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 12:50:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDB6C061755
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2020 09:50:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id j18so6925471wmi.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2020 09:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gmNdK7C7p3GOaWApd36jZcWDhYk6iZ0W3tnr0a0n+OI=;
        b=UV1C5lVGyVYPhy1ACNxRbBv1T2E0u9TbIlo3gbw5D+km3Hxhpd44uE0bR0NgQIyR5z
         CEA64JkQ+7Q2Psl2mtFxoo0nC3BdPJc3Of4r7aSbYFMSAACZWh1bXOQTO8YDad3fWWgN
         K8l0y6PBczMpx0uuPBqHs3xUiRsZxd7ShU2XkSUHsMNtFXcCL+ol/A7UztFniLe0xJAE
         7s+xPfjWGA17wz1BGuie+dd5alrnzCDi8ZBecTNhcMoEhKjbD74HaLL39/3Fu+eRNCyb
         rvEC3NryZrRvunf8Tc/6Q/2i0IqJeiPRE6xY/ZepCQ12KRmf43AIh5elJk+bjFQ9V9Pp
         Wl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gmNdK7C7p3GOaWApd36jZcWDhYk6iZ0W3tnr0a0n+OI=;
        b=uDJ+jI018FuJLMpa6t3ISAFKSDSKA6s4zviCwlhlQi9donWhjL+Vqx1f5kYkA/WaF8
         LIfhzmsoe8EyHOHcJObMonslVlJKfcNRBLmi/cJm86PD77WEKGOVHOuW7dFOfAmhMuVQ
         ylSecqaFv8jMkgyGC4yfVe8nTJsbeYMfjEGZzPoGq6OlyzhMNRnLIJnE5Ppva0T2PKDC
         RkmuE57OJ87Tmpg8Op/60nGQfDCeNvrZfRQqm3oe63S/Otvupjx1tLyyofsLtpsCoCnA
         RGhvy6viXrP1cDBxDQDssX07tHqoXBDLJ/YTrpaGWuWMVia8m+g5npQrqbLgThLp3ez2
         gLaw==
X-Gm-Message-State: AOAM5322lWF/ID8kfzuLtKY8J5Q0c31qjHzycUq4DAqyhR5yVm6Dw+xg
        n6YOxVDWwnfUIKi+qebkj7CCJt5II9DefbVFMBrW6o1g
X-Google-Smtp-Source: ABdhPJz3+cooAwaRo8+1tpx75vxAxm60Foult2K/XIP0RiZTGJfaTG6zxtWntsjb7an/rY+Obvw0gJdJWY0FyvPDabE=
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr4732693wmh.130.1594745439301;
 Tue, 14 Jul 2020 09:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRgVh9i-eBTXi5O1dLCwZ=kdmpakuP7K5xCVRkwhwTrB2Q@mail.gmail.com>
 <501e0c04-2b2b-a3e8-6172-890cb2b7e9cb@kernel.dk> <CAKq9yRhAQ_zyE8k5kDYvdh8qAwZZOANFvwaR_T_n66MkJ-=+3w@mail.gmail.com>
In-Reply-To: <CAKq9yRhAQ_zyE8k5kDYvdh8qAwZZOANFvwaR_T_n66MkJ-=+3w@mail.gmail.com>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Tue, 14 Jul 2020 17:50:12 +0100
Message-ID: <CAKq9yRgLkvd32Wt3zFo0SnBzzEtpbWp88sKsM__OpRTa-WHvNQ@mail.gmail.com>
Subject: Re: IORING_OP_FILES_UPDATE fail with ECANCELED when IOSQE_IO_LINK is used
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 14 Jul 2020 at 08:51, Daniele Salvatore Albano
<d.albano@gmail.com> wrote:
>
> Sure thing, I will send a patch later on.
>
> Thanks!
>
> On Tue, 14 Jul 2020, 03:20 Jens Axboe, <axboe@kernel.dk> wrote:
>>
>> On 7/13/20 4:55 PM, Daniele Salvatore Albano wrote:
>> > Hi everyone,
>> >
>> > I am trying to use IORING_OP_FILES_UPDATE  in combination with
>> > IOSQE_IO_LINK and IORING_OP_RECV / IORING_OP_RECV as linked op but I
>> > keep getting ECANCELED (errno 125).
>> >
>> > I am using io_uring (kernel 5.8.0-rc4 built 3 days ago) and liburing (tag 0.7).
>> >
>> > I went through the test cases and I wasn't able to find any
>> > combination of the OP and the flag and I can't find any related docs
>> > so I am not sure if the combo isn't allowed.
>> >
>> > Although I have found
>> > https://github.com/torvalds/linux/blob/v5.8-rc5/fs/io_uring.c#L4926
>> >
>> >  if (sqe->flags || sqe->ioprio || sqe->rw_flags)
>> >     return -EINVAL;
>> >
>> > Not sure if this is the reason for which the linked operation is
>> > failing, I don't see in the other *_prep sqe->flags being broadly
>> > checked in general.
>> >
>> > I wrote two simple test cases that perform the following sequence of operations:
>> > - open a local file (for the two test cases below /proc/cmdline)
>> > - IORING_OP_FILES_UPDATE +  IOSQE_IO_LINK (only in the first test case)
>> > - IORING_OP_READ + IOSQE_FIXED_FILE
>> >
>> > Here a small test case to trigger the issue I am facing
>> >
>> > int main() {
>> >     struct io_uring ring = {0};
>> >     uint32_t head, count = 0;
>> >     struct io_uring_sqe *sqe = NULL;
>> >     struct io_uring_cqe *cqe = NULL;
>> >     uint32_t files_map_count = 16;
>> >     const int *files_map_registered = malloc(sizeof(int) * files_map_count);
>> >     memset((void*)files_map_registered, 0, sizeof(int) * files_map_count);
>> >
>> >     io_uring_queue_init(16, &ring, 0);
>> >     io_uring_register_files(&ring, files_map_registered, files_map_count);
>> >
>> >     int fd = open("/proc/cmdline", O_RDONLY);
>> >     int fd_index = 10;
>> >
>> >     sqe = io_uring_get_sqe(&ring);
>> >     io_uring_prep_files_update(sqe, &fd, 1, fd_index);
>> >     io_uring_sqe_set_flags(sqe, IOSQE_IO_LINK);
>> >     sqe->user_data = 1;
>> >
>> >     char buffer[512] = {0};
>> >     sqe = io_uring_get_sqe(&ring);
>> >     io_uring_prep_read(sqe, fd_index, &buffer, sizeof(buffer), 0);
>> >     io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
>> >     sqe->user_data = 2;
>> >
>> >     io_uring_submit_and_wait(&ring, 2);
>> >
>> >     io_uring_for_each_cqe(&ring, head, cqe) {
>> >         count++;
>> >
>> >         fprintf(stdout, "count = %d\n", count);
>> >         fprintf(stdout, "cqe->res = %d\n", cqe->res);
>> >         fprintf(stdout, "cqe->user_data = %llu\n", cqe->user_data);
>> >         fprintf(stdout, "cqe->flags = %u\n", cqe->flags);
>> >     }
>> >
>> >     io_uring_cq_advance(&ring, count);
>> >
>> >     io_uring_unregister_files(&ring);
>> >     io_uring_queue_exit(&ring);
>> >
>> >     return 0;
>> > }
>> >
>> > It will report for both the cqes res = -125
>> >
>> > Instead if the code doesn't link and wait for the read it works as I
>> > am expecting.
>> >
>> > int main() {
>> >     struct io_uring ring = {0};
>> >     uint32_t head, count = 0;
>> >     char buffer[512] = {0};
>> >     struct io_uring_sqe *sqe = NULL;
>> >     struct io_uring_cqe *cqe = NULL;
>> >     uint32_t files_map_count = 16;
>> >     const int *files_map_registered = malloc(sizeof(int) * files_map_count);
>> >     memset((void*)files_map_registered, 0, sizeof(int) * files_map_count);
>> >
>> >     io_uring_queue_init(16, &ring, 0);
>> >     io_uring_register_files(&ring, files_map_registered, files_map_count);
>> >
>> >     int fd = open("/proc/cmdline", O_RDONLY);
>> >     int fd_index = 10;
>> >
>> >     sqe = io_uring_get_sqe(&ring);
>> >     io_uring_prep_files_update(sqe, &fd, 1, fd_index);
>> >     io_uring_sqe_set_flags(sqe, 0);
>> >     sqe->user_data = 1;
>> >
>> >     int exit_loop = 0;
>> >     do {
>> >         io_uring_submit_and_wait(&ring, 1);
>> >
>> >         io_uring_for_each_cqe(&ring, head, cqe) {
>> >             count++;
>> >
>> >             fprintf(stdout, "count = %d\n", count);
>> >             fprintf(stdout, "cqe->res = %d\n", cqe->res);
>> >             fprintf(stdout, "cqe->user_data = %llu\n", cqe->user_data);
>> >             fprintf(stdout, "cqe->flags = %u\n", cqe->flags);
>> >
>> >             if (cqe->user_data == 1) {
>> >                 sqe = io_uring_get_sqe(&ring);
>> >                 io_uring_prep_read(sqe, fd_index, &buffer, sizeof(buffer), 0);
>> >                 io_uring_sqe_set_flags(sqe, IOSQE_FIXED_FILE);
>> >                 sqe->user_data = 2;
>> >             } else {
>> >                 if (cqe->res >= 0) {
>> >                     fprintf(stdout, "buffer = <");
>> >                     fwrite(buffer, cqe->res, 1, stdout);
>> >                     fprintf(stdout, ">\n");
>> >                 }
>> >
>> >                 exit_loop = 1;
>> >             }
>> >         }
>> >
>> >         io_uring_cq_advance(&ring, count);
>> >     } while(exit_loop == 0);
>> >
>> >     io_uring_unregister_files(&ring);
>> >     io_uring_queue_exit(&ring);
>> >
>> >     return 0;
>> > }
>> >
>> > The output here is
>> > count = 1
>> > cqe->res = 1
>> > cqe->user_data = 1
>> > cqe->flags = 0
>> > count = 2
>> > cqe->res = 58
>> > cqe->user_data = 2
>> > cqe->flags = 0
>> > buffer = <initrd=....yada yada yada...>
>> >
>> > Is this the expected behaviour? If no, any hint? What am I doing wrong?
>> >
>> > If the expected behaviour is that IORING_OP_FILES_UPDATE can't be
>> > linked, how can I use it properly to issue a read or another op that
>> > requires to work with fds in a chain of operations?
>>
>> I think the sqe->flags should just be removed, as you're alluding to.
>> Care to send a patch for that? Then I can queue it up. We can even mark
>> it stable to ensure it gets back to older kernels.
>>
>> Probably just want to make it something ala:
>>
>> unsigned flags = READ_ONCE(sqe->flags);
>>
>> if (flags & (IOSQE_FIXED_FILE | IOSQE_BUFFER_SELECT))
>>         return -EINVAL;
>>
>> as those flags don't make sense, but the rest do.
>>
>> --
>> Jens Axboe
>>

TLDR;
Change done but the linked op still need to do not use
IOSQE_FIXED_FILE and use the original fd
I don't think that this is a problem at all because it still allows
the approach "submit & forget" as long as the first subsequent io op
is using the original fd and it's not using the registered index.

I can imagine people may expect to be able to use IOSQE_FIXED_FILE
with the linked op after IORING_OP_FILES_UPDATE but documenting it may
be enough also because the additional work may slow down various
things.

******
I applied the change but it wasn't still working as I was expecting,
after further investigation I discovered that it was trying to read
from the stdin because in my test case fd_index is 0.

When in sequence the userland code submits
- IORING_OP_FILES_UPDATE + IOSQE_IO_LINK
- IORING_OP_READ + IOSQE_FIXED_FILE

On the kernel side I am seeing (almost other calls):
- io_files_update_prep
- io_req_set_file
- io_read_prep
- io_files_update
- io_read

When io_req_set_file is executed, before io_files_update, the
registered files at offset 10 contains 0 that is the stdin.

This happens because, to my understanding, io_req_set_file it is
invoked by io_init_req in io_submit_sqes that is directly invoked by
the io_uring_enter syscal or the sq_thread.

For this to work it would have to re-fetch the new file pointer and
update the proper structs in req.

Having IORING_OP_FILES_UPDATE working with IOSQE_IO_LINK is already
great because it's just possible to invoke it and forget, using the
normal fd for the operations linked directly and without having really
keep tracking of the original fd: most likely if you are submitting
the files update you are doing it to submit an io op right after as
well so you probably have easy access or may have easy access to the
original fd.

With a test program I am now able to:
- submit IORING_OP_FILES_UPDATE with IOSQE_IO_LINK
- submit IORING_OP_READ (without IOSQE_FIXED_FILE)
- on completion
- submit IORING_OP_READ with IOSQE_FIXED_FILE

To be honest, I am not sure it's worth addressing this on the kernel
side because although I can easily imagine the expected behaviour is
"I set IORING_OP_FILES_UPDATE so I can use IOSQE_FIXED_FILE even in
the chain" (or at least it was mine).

This would require a series of changes for a very small number of use
cases, especially because the FD should be reloaded for all the ops in
the chain meanwhile they are processed:
- it's necessary to access the original fd so this would have to be
tracked down somewhere in io_kiocb and because all the io ops that can
use IOSQE_FIXED_FILE would require to potentially reload the fd it
would have to be added to a number of places
- it's of course possible to re-use something else but I don't have
the necessary expertise in io_uring to understand what
- all the ops using IOSQE_FIXED_FILE would have to check for
IOSQE_FIXED_FILE_RELOADFD and in case reload the fd

As consequence:
- if anything else can't be reused to store the fd, potentially grow io_kiocb
- slow down the io ops when have to reload the fd
- having to trigger an additional if because it would make sense
adding unlikely, it's and edge case and should be in the slow path

At the end, having to reload the fd may slightly impact the
performances of all the io ops and at the same time slow down a lot
the few operations for which would be required to reload the fd so
would just easier (and better) to pass the original fd in the
initially chained ops and use the registered fd index after.
******

What do you think?


Thanks!

Daniele
