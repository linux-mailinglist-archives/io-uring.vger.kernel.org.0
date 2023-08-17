Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072D077EE68
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 02:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347311AbjHQAkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 20:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347396AbjHQAj6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 20:39:58 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5A3E48;
        Wed, 16 Aug 2023 17:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com;
 s=s31663417; t=1692232794; x=1692837594; i=quwenruo.btrfs@gmx.com;
 bh=crClJ2MqEviUPw43+l7WcgfXudJuGDRQo1yGkeUqJxw=;
 h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
 b=D2HlA6Jvo5nAPW3bmSKw4LB2K1Pse5iZzchQ6hQGFPS9sc2kRHAI7t2XEUeT+dzp09NrEkl
 kKpVaM6akLhou3J3WKqcHXiCysO3Jpc/eBYcUIGEhHY7BImalDN7P53JN2+vz3rQQsrgoI7dZ
 5N35xOoxkk+zLeknWHtQ4vztvfSYPQ9tFs5yYyzTYS/cBVogevBMFMRLn5KH+JuELj/hEjexo
 vH8nYlj3fJGgALN8+jnoX94A+d47qMWT1AlLKaDFSGuvSYN5yvHa+i+Oj0jypw0NDXJIyDe8b
 zxF2ly8sNBBGRqNGu3aPF7Pm8swuMAeJyzjL+2bRvtJ5C8jzrmhA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MQe5u-1q9ph12sli-00Nic6; Thu, 17
 Aug 2023 02:39:54 +0200
Message-ID: <7c337afe-90ee-4a7f-9470-bdb2a3636e26@gmx.com>
Date:   Thu, 17 Aug 2023 08:40:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
 <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
 <7f8f397a-ebcb-46ca-9211-f9c8efd61b8a@kernel.dk>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCY00iVQUJDToH
 pgAKCRDCPZHzoSX+qNKACACkjDLzCvcFuDlgqCiS4ajHAo6twGra3uGgY2klo3S4JespWifr
 BLPPak74oOShqNZ8yWzB1Bkz1u93Ifx3c3H0r2vLWrImoP5eQdymVqMWmDAq+sV1Koyt8gXQ
 XPD2jQCrfR9nUuV1F3Z4Lgo+6I5LjuXBVEayFdz/VYK63+YLEAlSowCF72Lkz06TmaI0XMyj
 jgRNGM2MRgfxbprCcsgUypaDfmhY2nrhIzPUICURfp9t/65+/PLlV4nYs+DtSwPyNjkPX72+
 LdyIdY+BqS8cZbPG5spCyJIlZonADojLDYQq4QnufARU51zyVjzTXMg5gAttDZwTH+8LbNI4
 mm2YzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCY00ibgUJDToHvwAK
 CRDCPZHzoSX+qK6vB/9yyZlsS+ijtsvwYDjGA2WhVhN07Xa5SBBvGCAycyGGzSMkOJcOtUUf
 tD+ADyrLbLuVSfRN1ke738UojphwkSFj4t9scG5A+U8GgOZtrlYOsY2+cG3R5vjoXUgXMP37
 INfWh0KbJodf0G48xouesn08cbfUdlphSMXujCA8y5TcNyRuNv2q5Nizl8sKhUZzh4BascoK
 DChBuznBsucCTAGrwPgG4/ul6HnWE8DipMKvkV9ob1xJS2W4WJRPp6QdVrBWJ9cCdtpR6GbL
 iQi22uZXoSPv/0oUrGU+U5X4IvdnvT+8viPzszL5wXswJZfqfy8tmHM85yjObVdIG6AlnrrD
In-Reply-To: <7f8f397a-ebcb-46ca-9211-f9c8efd61b8a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7q1a9h/0qdAaMzcA3C5bYVDDFHlFyaQ2S1ges1sAJ3bCXHvHe4K
 H4V72QI1s5coKGzf8E+4pJ1hn56/f55+o5Io7rVUPZE1p5p7inENbQCNbS1hUS9oZqI/F4j
 sPYsBi97M3A/JwyQITssfFkdMLe/VFIR+iwQ6tKVCNZmp+2r4y8hZ0uuIVIbOZ17NPrG8Lj
 hg5+n1qGLNau4hqW8yDoQ==
UI-OutboundReport: notjunk:1;M01:P0:dCdDvZGUPqE=;4NTRnkizWaydPp2sKzik7EBZtXU
 vkqlcr+g8Cro8zQqCBGZ3TI2HEGX3dqFiztwXtxyZFWqvnLIlrxa+kTajdCbXs1Itc/NbDFAg
 qrtoyQpl9V9w2sZ9md88r0cHsigb6Eib1N2DmpaTXBdvNtGvfwHqo6LDxGTSDcofWfmpFFHlS
 GHSQk4c2jSpFpNKyQ8lfb0ADFluyKkfgVGilo5RFFVTgQGGo+p024opw3u5aW2hk9XJeqcG68
 2Ze+gAOYm8KAUS0bwiSfeTW246B+lta3kwFfriSOj1hQ7Cdkv++je0a/gdL04g7BeDj4Kf8wt
 H15KD7l9dpkZcAm70aTOnkFGWgJAIOZGTLAviSbThboySYQOqRuNpwphjTu4Ypeh4mQSbVhCV
 vdQYBU5jr5d05twSa5hxF5FU0yUUrPI1g2mX1DIOuF/v5iC8tkocUbVaL2PUPDV+enZ+Iw8iT
 HBgKjHFcO6M2dmX+fc44glxG+BIjC59F1xGZ9v/+s57Zx5wBGFi5Qawz3SsBZe8P3tb27Otd7
 1y7PcEzTfr4HzblcS7NGUOjygOjyiAv6X8E8fIWQMg1UNkkuTO705nNUS+bYJOnRxa2eGqbnj
 A/pjZaEhFdvTi1xe1zHxlHqzD6LuR2IdfugNFid86VrmR59/pJ1moG9ZxbRPaBEkV7IFoajGu
 2ggi/5S7zq+MHkbQpxKER4M+xNHVYxgsMZIsC2PwGkBFoUo6Zep6lprtrhPR2scYiT8kVz6XT
 +yESzyBzHBEyPjxNmDeu4D09mnP5ccSjqSfn71vPAN0VhrFN3NzJsCvnrx5lY8FqeCq7qjWBt
 HpG2nIuLOSSE4H8GUot4pOHePtGpbGHGQe6oPXuxFuEcuKVg7cIeMo22w0L37k4qlMCU1W6Z1
 pokYKfRpVmhWuJk+akDCjz8nL0oAtLCVOeplRWnNBXBMbF1wH8k2P6tTEfgKof7rvxe53S1k+
 2yomniAFsTOIhY0xrVz+iU20oWM=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023/8/17 06:36, Jens Axboe wrote:
> On 8/16/23 3:46 PM, Qu Wenruo wrote:
>>> Is that write back caching enabled?
>>> Write back caching with volatile write cache? For your device, can you
>>> do:
>>>
>>> $ grep . /sys/block/$dev/queue/*
>
> You didn't answer this one either.
>
Sorry, here is the output:

$ grep . /sys/block/vdb/queue/*
/sys/block/vdb/queue/add_random:0
/sys/block/vdb/queue/chunk_sectors:0
/sys/block/vdb/queue/dax:0
/sys/block/vdb/queue/discard_granularity:512
/sys/block/vdb/queue/discard_max_bytes:2147483136
/sys/block/vdb/queue/discard_max_hw_bytes:2147483136
/sys/block/vdb/queue/discard_zeroes_data:0
/sys/block/vdb/queue/dma_alignment:511
/sys/block/vdb/queue/fua:0
/sys/block/vdb/queue/hw_sector_size:512
/sys/block/vdb/queue/io_poll:0
/sys/block/vdb/queue/io_poll_delay:-1
/sys/block/vdb/queue/iostats:1
/sys/block/vdb/queue/logical_block_size:512
/sys/block/vdb/queue/max_discard_segments:1
/sys/block/vdb/queue/max_hw_sectors_kb:2147483647
/sys/block/vdb/queue/max_integrity_segments:0
/sys/block/vdb/queue/max_sectors_kb:1280
/sys/block/vdb/queue/max_segment_size:4294967295
/sys/block/vdb/queue/max_segments:254
/sys/block/vdb/queue/minimum_io_size:512
/sys/block/vdb/queue/nomerges:0
/sys/block/vdb/queue/nr_requests:256
/sys/block/vdb/queue/nr_zones:0
/sys/block/vdb/queue/optimal_io_size:0
/sys/block/vdb/queue/physical_block_size:512
/sys/block/vdb/queue/read_ahead_kb:128
/sys/block/vdb/queue/rotational:1
/sys/block/vdb/queue/rq_affinity:1
/sys/block/vdb/queue/scheduler:[none] mq-deadline kyber bfq
/sys/block/vdb/queue/stable_writes:0
/sys/block/vdb/queue/throttle_sample_time:100
/sys/block/vdb/queue/virt_boundary_mask:0
/sys/block/vdb/queue/wbt_lat_usec:75000
/sys/block/vdb/queue/write_cache:write back
/sys/block/vdb/queue/write_same_max_bytes:0
/sys/block/vdb/queue/write_zeroes_max_bytes:2147483136
/sys/block/vdb/queue/zone_append_max_bytes:0
/sys/block/vdb/queue/zone_write_granularity:0
/sys/block/vdb/queue/zoned:none

Thanks,
Qu
