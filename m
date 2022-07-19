Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF757923A
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 06:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiGSEwx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jul 2022 00:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiGSEww (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jul 2022 00:52:52 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BBA3AB1A
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 21:52:50 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220719045248epoutp046811e4882a6997591fa72c4d2c89bf36~DIegn2C5e3078530785epoutp044
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 04:52:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220719045248epoutp046811e4882a6997591fa72c4d2c89bf36~DIegn2C5e3078530785epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1658206368;
        bh=VqeeiIw8zv5QdFlqpTPrDDcYjaoPONkCSpNhbPg+OfE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MHFFgoQpiEp8CBhJ7F1DzrH+mavwonJ1ME7wYm7HTRua2ri9XChIDARz4qL5kkcEe
         7wr2vnP5M3fa70qGHDg5j2iY7P4hUdrFeP6gZfOzr4nI8T7xgxj4LZ6l67MoSUjyFW
         WO8Zj2yvKT2vMkpd0s7KXZwO/3E8yuZKXd7H+F4w=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220719045248epcas5p302d8e1f8bccbfef23611d9797c3c44a1~DIegJBJNl2325523255epcas5p3K;
        Tue, 19 Jul 2022 04:52:48 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Ln5zv66zWz4x9QF; Tue, 19 Jul
        2022 04:52:43 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.96.09662.B9836D26; Tue, 19 Jul 2022 13:52:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220719045243epcas5p3a41ed724b270ac45c58e1cba8bc2ba14~DIebgK1uI2118121181epcas5p3D;
        Tue, 19 Jul 2022 04:52:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220719045243epsmtrp1ccfb42b24616dd8f333f46dc1320aa3c~DIebfAakK1146611466epsmtrp1C;
        Tue, 19 Jul 2022 04:52:43 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-ab-62d6389b7778
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.1A.08802.B9836D26; Tue, 19 Jul 2022 13:52:43 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220719045241epsmtip29d9db9bab2732e54825a90094ab26b07~DIeZzI_S30923609236epsmtip2y;
        Tue, 19 Jul 2022 04:52:41 +0000 (GMT)
Date:   Tue, 19 Jul 2022 10:17:17 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Jens Axboe <axboe@kernel.dk>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com,
        ankit.kumar@samsung.com
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
Message-ID: <20220719044717.GA22571@test-zns>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRzjLFg9B4wL7GvW3WY-qM4BoqqcpyS0gW8MUbQ9BD2mg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmhu5si2tJBpM+GVhMP6xosebKb3aL
        1Xf72SzubfvFZvGu9RyLRefpC0wWe29pW8xf9pTd4kPPIzaLGxOeMlrcnjSdxYHbo3nBHRaP
        y2dLPTat6mTz2Lyk3mPt3heMHn1bVjF6HN2/iM3j8ya5AI6obJuM1MSU1CKF1Lzk/JTMvHRb
        Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoCuVFMoSc0qBQgGJxcVK+nY2RfmlJakK
        GfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZUyd/Zi+4JlXRsfsZawPjZLEu
        Rk4OCQETiYaJtxlBbCGB3YwS3XcDIexPjBKfvyl3MXIB2Z8ZJZZcX84G0/Cr9xQjRGIXo8TK
        d7PYIZxnjBLvnvYxg1SxCKhKnDo+GaiKg4NNQFPiwuRSkLCIgIrE4qfrwZqZBfYySWz61MME
        khAWCJZ40bYTbAOvgK5Ew5VdrBC2oMTJmU9YQGxOgUCJ6d97wU4VFVCWOLDtOBPERUs5JB4t
        cwHZJSHgItHQHQMRFpZ4dXwLO4QtJfGyvw3KTpa4NPMcVGuJxOM9B6Fse4nWU/1g5zMLZEis
        7L3KBmHzSfT+fsIEMZ5XoqNNCKJcUeLepKesELa4xMMZS6BsD4nOiRuYIYF4jlli+wqeCYxy
        s5A8MwvJBgjbSqLzQxPrLKANzALSEsv/cUCYmhLrd+kvYGRdxSiZWlCcm55abFpgmJdaDo/g
        5PzcTYzgRKvluYPx7oMPeocYmTgYDzFKcDArifCK1F5OEuJNSaysSi3Kjy8qzUktPsRoCoyc
        icxSosn5wFSfVxJvaGJpYGJmZmZiaWxmqCTO63V1U5KQQHpiSWp2ampBahFMHxMHp1QDE6dt
        TOjum0070q2kXtdwBYnN9292drK0EXn4zWONyNfqVUnfxbqi335LN/C9EM6UP1HZ/MXZTqmH
        e7j4d35SdJpb7//3Wvqd7HtTZkx43KLbfjX142Tm5fc8FgtLbvqYF21cqH3po6j/LvVpZdNP
        TefccfPz7E0+qfV7K88mrN7dfO7QxrtudSrlnfGbymWjSpnFjqvZMbhl7Vmq1Zm7+NTTR9uj
        9h/JcND/rXB1Z+mE5Vk5ySq3D+9u6pxxLkFSSfXqotdP455NtxENUYo8sH6F3VbRoEc9OanH
        q143d+otnvf6tI8rs+23O8I2aj+P7/GwZc2LbHu/56PCPpvK9QIpP/gm/1m+kWP/jjuLYpVY
        ijMSDbWYi4oTAfJlMXc9BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSvO5si2tJBv/3cVhMP6xosebKb3aL
        1Xf72SzubfvFZvGu9RyLRefpC0wWe29pW8xf9pTd4kPPIzaLGxOeMlrcnjSdxYHbo3nBHRaP
        y2dLPTat6mTz2Lyk3mPt3heMHn1bVjF6HN2/iM3j8ya5AI4oLpuU1JzMstQifbsEroybx6cx
        F3RIVOzZNoW1gfG+cBcjJ4eEgInEr95TjCC2kMAORom2q6wQcXGJ5ms/2CFsYYmV/54D2VxA
        NU8YJRa+uglWxCKgKnHq+GSgZg4ONgFNiQuTS0HCIgIqEoufrgebySywn0li10N/EFtYIFji
        RdtONhCbV0BXouHKLlaImeeYJbbufM8MkRCUODnzCQtEs5nEvM0PmUHmMwtISyz/xwES5hQI
        lJj+vRdsvqiAssSBbceZJjAKzkLSPQtJ9yyE7gWMzKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz
        0vWS83M3MYLjR0trB+OeVR/0DjEycTAeYpTgYFYS4RWpvZwkxJuSWFmVWpQfX1Sak1p8iFGa
        g0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA1MJ59Ginrrb18p/eu89khQk7bCP/cqcybN7
        zP9WX1W6EsAhW/MxKkNDtfu85Y/ds7xXGHKqnZN1m7Ftfoz+8fb3KRnnqp3YT4tfyTw5j6eg
        09goICF+Z7p16EI5pVSROTbx0f+3LJ4tX3tQOz9Vl/n4o6drJ5VwythZy09MOnOqOtrx7wbe
        7nUnb4i6p4rNWMjXwFN+o6uv8eQpx71ZDP3CblmPveOn5hwSeZUh2Ptxq8y1Znc2wYYT1d36
        M+5YT2RaVD9/+zJJDQsfPsHgt0XLisRibWv9mzoabfguyQaE7b1Y92Bmls2JVcyHZn/jUT53
        7Uzy7efbzcQqOzynbUpbLhRXPzVt0ZxT00PElFiKMxINtZiLihMBbEqq5Q4DAAA=
X-CMS-MailID: 20220719045243epcas5p3a41ed724b270ac45c58e1cba8bc2ba14
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_a32a6_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220718215605epcas5p4332ce1e7321243d7052834b0804c91c6
References: <20220715191622.2310436-1-mcgrof@kernel.org>
        <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
        <CAHC9VhRzm=1mh9bZKEdLSG0vet=amQDVpuZk+1shMuXYLV_qoQ@mail.gmail.com>
        <CAHC9VhQm3CBUkVz2OHBmuRi1VDNxvfWs-tFT2UO9LKMbO7YJMg@mail.gmail.com>
        <e139a585-ece7-7813-7c90-9ffc3a924a87@schaufler-ca.com>
        <CGME20220718215605epcas5p4332ce1e7321243d7052834b0804c91c6@epcas5p4.samsung.com>
        <CAHC9VhRzjLFg9B4wL7GvW3WY-qM4BoqqcpyS0gW8MUbQ9BD2mg@mail.gmail.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_a32a6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Jul 18, 2022 at 05:52:01PM -0400, Paul Moore wrote:
>On Mon, Jul 18, 2022 at 1:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 7/15/2022 8:33 PM, Paul Moore wrote:
>> > On Fri, Jul 15, 2022 at 3:52 PM Paul Moore <paul@paul-moore.com> wrote:
>> >> On Fri, Jul 15, 2022 at 3:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>> >>> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
>> >>>> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
>> >>>> add infrastructure for uring-cmd"), this extended the struct
>> >>>> file_operations to allow a new command which each subsystem can use
>> >>>> to enable command passthrough. Add an LSM specific for the command
>> >>>> passthrough which enables LSMs to inspect the command details.
>> >>>>
>> >>>> This was discussed long ago without no clear pointer for something
>> >>>> conclusive, so this enables LSMs to at least reject this new file
>> >>>> operation.
>> >>> From an io_uring perspective, this looks fine to me. It may be easier if
>> >>> I take this through my tree due to the moving of the files, or the
>> >>> security side can do it but it'd have to then wait for merge window (and
>> >>> post io_uring branch merge) to do so. Just let me know. If done outside
>> >>> of my tree, feel free to add:
>> > I forgot to add this earlier ... let's see how the timing goes, I
>> > don't expect the LSM/Smack/SELinux bits to be ready and tested before
>> > the merge window opens so I'm guessing this will not be an issue in
>> > practice, but thanks for the heads-up.
>>
>> I have a patch that may or may not be appropriate. I ran the
>> liburing tests without (additional) failures, but it looks like
>> there isn't anything there testing uring_cmd. Do you have a
>> test tucked away somewhere I can use?

Earlier testing was done using fio. liburing tests need a formal review
in list. Tree is here -
https://github.com/ankit-sam/liburing/tree/uring-pt
It adds new "test/io_uring_passthrough.t", which can be run this way:

./test/io_uring_passthrough.t /dev/ng0n1

Requires nvme device (/dev/ng0n1). And admin-access as well, as this
is raw open. FWIW, each passthrough command (at nvme driver level) is
also guarded by admin-access.

Ankit (CCed) has the plans to post it (will keep you guys in loop) after
bit more testing with 5.20 branch.

>All I have at the moment is the audit-testsuite io_uring test (link
>below) which is lacking a test for the io_uring CMD command.  I plan
>on adding that, but I haven't finished the SELinux patch yet.
>
>* https://protect2.fireeye.com/v1/url?k=9cb2caea-fd39dfd9-9cb341a5-000babff9bb7-e1f9086bae09b852&q=1&e=b1985274-4644-447d-be8c-16f520cadbd9&u=https%3A%2F%2Fgithub.com%2Flinux-audit%2Faudit-testsuite%2Ftree%2Fmain%2Ftests%2Fio_uring
>
>(Side note: there will be a SELinux io_uring test similar to the
>audit-testsuite test, but that effort was delayed due to lack of
>io_uring support in the Fedora policy for a while; it's working now,
>but the SELinux/SCTP issues have been stealing my time lately.)

------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_a32a6_
Content-Type: text/plain; charset="utf-8"


------OEEzMZle2oafIX2psGkTvPl59BrXC3apHO-sLjJPJT1qP5Pe=_a32a6_--
