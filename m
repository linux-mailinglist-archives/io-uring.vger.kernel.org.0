Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5803538F1
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 18:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhDDQzS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 12:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhDDQzR (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 4 Apr 2021 12:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B18861368;
        Sun,  4 Apr 2021 16:55:10 +0000 (UTC)
Date:   Sun, 4 Apr 2021 18:55:07 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+c88a7030da47945a3cc3@syzkaller.appspotmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, io-uring@vger.kernel.org
Subject: Re: [syzbot] WARNING in mntput_no_expire (2)
Message-ID: <20210404165507.gbgtvxkfhyd3urb6@wittgenstein>
References: <20210401154515.k24qdd2lzhtneu47@wittgenstein>
 <90e7e339-eaec-adb2-cfed-6dc058a117a3@kernel.dk>
 <20210401174613.vymhhrfsemypougv@wittgenstein>
 <20210401175919.jpiylhfrlb4xb67u@wittgenstein>
 <YGYa0B4gabEYi2Tx@zeniv-ca.linux.org.uk>
 <YGkloJhMFc4hEatk@zeniv-ca.linux.org.uk>
 <20210404113445.xo6ntgfpxigcb3x6@wittgenstein>
 <YGnhkoTfVfMSMPpK@zeniv-ca.linux.org.uk>
 <20210404164040.vtxdcfzgliuzghwk@wittgenstein>
 <20210404165202.2v24vaeyngowqdln@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210404165202.2v24vaeyngowqdln@wittgenstein>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04, 2021 at 06:52:08PM +0200, Christian Brauner wrote:
> On Sun, Apr 04, 2021 at 06:40:40PM +0200, Christian Brauner wrote:
> > On Sun, Apr 04, 2021 at 03:56:02PM +0000, Al Viro wrote:
> > > On Sun, Apr 04, 2021 at 01:34:45PM +0200, Christian Brauner wrote:
> > > 
> > > > Sorry for not replying to your earlier mail but I've been debugging this
> > > > too. My current theory is that it's related to LOOKUP_ROOT_GRABBED when
> > > > LOOKUP_CACHED is specified _possibly_ with an interaction how
> > > > create_io_thread() is created with CLONE_FS. The reproducer requires you
> > > > either have called pivot_root() or chroot() in order for the failure to
> > > > happen. So I think the fact that we skip legitimize_root() when
> > > > LOOKUP_CACHED is set might figure into this. I can keep digging.
> > > > 
> > > 
> > > > Funny enough I already placed a printk statement into the place you
> > > > wanted one too so I just amended mine. Here's what you get:
> > > > 
> > > > If pivot pivot_root() is used before the chroot() you get:
> > > > 
> > > > [  637.464555] AAAA: count(-1) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(579) | dev(tmpfs)
> > > > 
> > > > if you only call chroot, i.e. make the pivot_root() branch a simple
> > > > if (true) you get:
> > > > 
> > > > [  955.206117] AAAA: count(-2) | mnt_mntpoint(/) | mnt->mnt.mnt_root(/) | id(580) | dev(tmpfs)
> > > 
> > > Very interesting.  What happens if you call loop() twice?  And now I wonder
> > > whether it's root or cwd, actually...  Hmm...
> > > 
> > > How about this:
> > > 	fd = open("/proc/self/mountinfo", 0);
> > > 	mkdir("./newroot/foo", 0777);
> > > 	mount("./newroot/foo", "./newroot/foo", 0, MS_BIND, NULL);
> > > 	chroot("./newroot");
> > > 	chdir("/foo");
> > > 	while (1) {
> > > 		static char buf[4096];
> > > 		int n = read(fd, buf, 4096);
> > > 		if (n <= 0)
> > > 			break;
> > > 		write(1, buf, n);
> > > 	}
> > > 	close(fd);
> > > 	drop_caps();
> > > 	loop();
> > > as the end of namespace_sandbox_proc(), instead of
> > > 	chroot("./newroot");
> > > 	chdir("/");
> > > 	drop_caps();
> > > 	loop();
> > > sequence we have there?
> > 
> > Uhum, well then we oops properly with a null-deref.
> 
> And note that the reproducer also requires CLONE_NEWNS which causes the
> fs_struct to be unshared as well. I'm not completely in the clear what
> would happen if a new io worker thread were to be created after the
> caller has called unshare(CLONE_NEWNS).

And here's a non-null-deref version:

[  647.257107] AAAA: count(-1) | mnt_mntpoint(foo) | mnt->mnt.mnt_root(foo) | id(1358) | dev(tmpfs)

which is

1358 1326 0:66 /newroot/foo /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/foo rw,relatime - tmpfs  rw

Just for kicks, here's the full mount table:

1224 513 8:2 / / rw,relatime - ext4 /dev/sda2 rw
1225 1224 0:5 / /dev rw,nosuid,noexec,relatime - devtmpfs udev rw,size=302716k,nr_inodes=75679,mode=755
1226 1225 0:26 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts rw,gid=5,mode=620,ptmxmode=000
1227 1225 0:28 / /dev/shm rw,nosuid,nodev - tmpfs tmpfs rw
1228 1225 0:48 / /dev/hugepages rw,relatime - hugetlbfs hugetlbfs rw,pagesize=2M
1229 1225 0:21 / /dev/mqueue rw,nosuid,nodev,noexec,relatime - mqueue mqueue rw
1230 1224 0:27 / /run rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs rw,size=62152k,mode=755
1231 1230 0:29 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs tmpfs rw,size=5120k
1232 1230 0:49 / /run/lxd_agent rw,relatime - tmpfs tmpfs rw,size=51200k,mode=700
1233 1230 0:59 / /run/user/1000 rw,nosuid,nodev,relatime - tmpfs tmpfs rw,size=62148k,nr_inodes=15537,mode=700,uid=1000,gid=1000
1234 1224 0:24 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
1235 1234 0:6 / /sys/kernel/security rw,nosuid,nodev,noexec,relatime - securityfs securityfs rw
1236 1234 0:30 / /sys/fs/cgroup ro,nosuid,nodev,noexec - tmpfs tmpfs ro,size=4096k,nr_inodes=1024,mode=755
1237 1236 0:31 /../../.. /sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime - cgroup2 cgroup2 rw
1238 1236 0:32 /../../.. /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,xattr,name=systemd
1239 1236 0:36 / /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,perf_event
1240 1236 0:37 /.. /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,blkio
1241 1236 0:38 / /sys/fs/cgroup/rdma rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,rdma
1242 1236 0:39 /.. /sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpu,cpuacct
1243 1236 0:40 / /sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,net_cls,net_prio
1244 1236 0:41 /.. /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,devices
1245 1236 0:42 /../../.. /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,memory
1246 1236 0:43 / /sys/fs/cgroup/hugetlb rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,hugetlb
1247 1236 0:44 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpuset,clone_children
1248 1236 0:45 /../../.. /sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,pids
1249 1236 0:46 /../../.. /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
1250 1234 0:33 / /sys/fs/pstore rw,nosuid,nodev,noexec,relatime - pstore pstore rw
1251 1234 0:34 / /sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime - efivarfs efivarfs rw
1252 1234 0:35 / /sys/fs/bpf rw,nosuid,nodev,noexec,relatime - bpf none rw,mode=700
1253 1234 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime - debugfs debugfs rw
1254 1234 0:12 / /sys/kernel/tracing rw,nosuid,nodev,noexec,relatime - tracefs tracefs rw
1255 1234 0:51 / /sys/fs/fuse/connections rw,nosuid,nodev,noexec,relatime - fusectl fusectl rw
1256 1234 0:20 / /sys/kernel/config rw,nosuid,nodev,noexec,relatime - configfs configfs rw
1257 1224 0:25 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
1258 1257 0:47 / /proc/sys/fs/binfmt_misc rw,relatime - autofs systemd-1 rw,fd=29,pgrp=0,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=34137
1259 1258 0:52 / /proc/sys/fs/binfmt_misc rw,nosuid,nodev,noexec,relatime - binfmt_misc binfmt_misc rw
1260 1224 0:50 / /home/ubuntu/src/compiled rw,relatime - virtiofs lxd_lxc rw
1261 1224 8:1 / /boot/efi rw,relatime - vfat /dev/sda1 rw,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro
1262 1224 0:57 / /var/lib/lxcfs rw,nosuid,nodev,relatime - fuse.lxcfs lxcfs rw,user_id=0,group_id=0,allow_other
1263 1224 0:60 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp rw,relatime - tmpfs  rw
1264 1263 0:5 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/dev rw,nosuid,noexec,relatime - devtmpfs udev rw,size=302716k,nr_inodes=75679,mode=755
1265 1264 0:26 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/dev/pts rw,nosuid,noexec,relatime - devpts devpts rw,gid=5,mode=620,ptmxmode=000
1266 1264 0:28 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/dev/shm rw,nosuid,nodev - tmpfs tmpfs rw
1267 1264 0:48 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/dev/hugepages rw,relatime - hugetlbfs hugetlbfs rw,pagesize=2M
1268 1264 0:21 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/dev/mqueue rw,nosuid,nodev,noexec,relatime - mqueue mqueue rw
1269 1263 0:61 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/proc rw,relatime - proc none rw
1270 1263 0:24 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
1271 1270 0:6 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/kernel/security rw,nosuid,nodev,noexec,relatime - securityfs securityfs rw
1272 1270 0:30 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup ro,nosuid,nodev,noexec - tmpfs tmpfs ro,size=4096k,nr_inodes=1024,mode=755
1273 1272 0:31 /../../.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime - cgroup2 cgroup2 rw
1274 1272 0:32 /../../.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,xattr,name=systemd
1275 1272 0:36 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,perf_event
1276 1272 0:37 /.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,blkio
1277 1272 0:38 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/rdma rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,rdma
1278 1272 0:39 /.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpu,cpuacct
1279 1272 0:40 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,net_cls,net_prio
1280 1272 0:41 /.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,devices
1281 1272 0:42 /../../.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,memory
1282 1272 0:43 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/hugetlb rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,hugetlb
1283 1272 0:44 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpuset,clone_children
1284 1272 0:45 /../../.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,pids
1285 1272 0:46 /../../.. /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
1286 1270 0:33 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/pstore rw,nosuid,nodev,noexec,relatime - pstore pstore rw
1287 1270 0:34 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime - efivarfs efivarfs rw
1288 1270 0:35 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/bpf rw,nosuid,nodev,noexec,relatime - bpf none rw,mode=700
1289 1270 0:7 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/kernel/debug rw,nosuid,nodev,noexec,relatime - debugfs debugfs rw
1290 1270 0:12 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/kernel/tracing rw,nosuid,nodev,noexec,relatime - tracefs tracefs rw
1291 1270 0:51 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/fs/fuse/connections rw,nosuid,nodev,noexec,relatime - fusectl fusectl rw
1292 1270 0:20 / /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/sys/kernel/config rw,nosuid,nodev,noexec,relatime - configfs configfs rw
1293 1263 0:60 /newroot/foo /home/ubuntu/syzkaller.qO1bUT/syz-tmp/newroot/foo rw,relatime - tmpfs  rw
1294 1224 0:62 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp rw,relatime - tmpfs  rw
1295 1294 0:5 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/dev rw,nosuid,noexec,relatime - devtmpfs udev rw,size=302716k,nr_inodes=75679,mode=755
1296 1295 0:26 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/dev/pts rw,nosuid,noexec,relatime - devpts devpts rw,gid=5,mode=620,ptmxmode=000
1297 1295 0:28 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/dev/shm rw,nosuid,nodev - tmpfs tmpfs rw
1298 1295 0:48 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/dev/hugepages rw,relatime - hugetlbfs hugetlbfs rw,pagesize=2M
1299 1295 0:21 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/dev/mqueue rw,nosuid,nodev,noexec,relatime - mqueue mqueue rw
1300 1294 0:63 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/proc rw,relatime - proc none rw
1301 1294 0:24 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
1302 1301 0:6 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/kernel/security rw,nosuid,nodev,noexec,relatime - securityfs securityfs rw
1303 1301 0:30 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup ro,nosuid,nodev,noexec - tmpfs tmpfs ro,size=4096k,nr_inodes=1024,mode=755
1304 1303 0:31 /../../.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime - cgroup2 cgroup2 rw
1305 1303 0:32 /../../.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,xattr,name=systemd
1306 1303 0:36 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,perf_event
1307 1303 0:37 /.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,blkio
1308 1303 0:38 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/rdma rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,rdma
1309 1303 0:39 /.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpu,cpuacct
1310 1303 0:40 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,net_cls,net_prio
1311 1303 0:41 /.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,devices
1312 1303 0:42 /../../.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,memory
1313 1303 0:43 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/hugetlb rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,hugetlb
1314 1303 0:44 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpuset,clone_children
1315 1303 0:45 /../../.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,pids
1316 1303 0:46 /../../.. /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
1317 1301 0:33 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/pstore rw,nosuid,nodev,noexec,relatime - pstore pstore rw
1318 1301 0:34 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime - efivarfs efivarfs rw
1319 1301 0:35 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/bpf rw,nosuid,nodev,noexec,relatime - bpf none rw,mode=700
1320 1301 0:7 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/kernel/debug rw,nosuid,nodev,noexec,relatime - debugfs debugfs rw
1321 1301 0:12 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/kernel/tracing rw,nosuid,nodev,noexec,relatime - tracefs tracefs rw
1322 1301 0:51 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/fs/fuse/connections rw,nosuid,nodev,noexec,relatime - fusectl fusectl rw
1323 1301 0:20 / /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/sys/kernel/config rw,nosuid,nodev,noexec,relatime - configfs configfs rw
1324 1294 0:62 /newroot/foo /home/ubuntu/syzkaller.AVk8bL/syz-tmp/newroot/foo rw,relatime - tmpfs  rw
1326 1224 0:66 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp rw,relatime - tmpfs  rw
1327 1326 0:5 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/dev rw,nosuid,noexec,relatime - devtmpfs udev rw,size=302716k,nr_inodes=75679,mode=755
1328 1327 0:26 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/dev/pts rw,nosuid,noexec,relatime - devpts devpts rw,gid=5,mode=620,ptmxmode=000
1329 1327 0:28 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/dev/shm rw,nosuid,nodev - tmpfs tmpfs rw
1330 1327 0:48 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/dev/hugepages rw,relatime - hugetlbfs hugetlbfs rw,pagesize=2M
1331 1327 0:21 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/dev/mqueue rw,nosuid,nodev,noexec,relatime - mqueue mqueue rw
1332 1326 0:67 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/proc rw,relatime - proc none rw
1333 1326 0:24 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
1334 1333 0:6 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/kernel/security rw,nosuid,nodev,noexec,relatime - securityfs securityfs rw
1335 1333 0:30 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup ro,nosuid,nodev,noexec - tmpfs tmpfs ro,size=4096k,nr_inodes=1024,mode=755
1336 1335 0:31 /../../.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/unified rw,nosuid,nodev,noexec,relatime - cgroup2 cgroup2 rw
1337 1335 0:32 /../../.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,xattr,name=systemd
1338 1335 0:36 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,perf_event
1339 1335 0:37 /.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,blkio
1340 1335 0:38 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/rdma rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,rdma
1341 1335 0:39 /.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/cpu,cpuacct rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpu,cpuacct
1342 1335 0:40 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/net_cls,net_prio rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,net_cls,net_prio
1343 1335 0:41 /.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,devices
1344 1335 0:42 /../../.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,memory
1345 1335 0:43 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/hugetlb rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,hugetlb
1346 1335 0:44 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,cpuset,clone_children
1347 1335 0:45 /../../.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/pids rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,pids
1348 1335 0:46 /../../.. /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime - cgroup cgroup rw,freezer
1349 1333 0:33 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/pstore rw,nosuid,nodev,noexec,relatime - pstore pstore rw
1350 1333 0:34 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/firmware/efi/efivars rw,nosuid,nodev,noexec,relatime - efivarfs efivarfs rw
1351 1333 0:35 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/bpf rw,nosuid,nodev,noexec,relatime - bpf none rw,mode=700
1352 1333 0:7 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/kernel/debug rw,nosuid,nodev,noexec,relatime - debugfs debugfs rw
1353 1333 0:12 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/kernel/tracing rw,nosuid,nodev,noexec,relatime - tracefs tracefs rw
1354 1333 0:51 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/fs/fuse/connections rw,nosuid,nodev,noexec,relatime - fusectl fusectl rw
1355 1333 0:20 / /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/sys/kernel/config rw,nosuid,nodev,noexec,relatime - configfs configfs rw
1358 1326 0:66 /newroot/foo /home/ubuntu/syzkaller.Wgqj6W/syz-tmp/newroot/foo rw,relatime - tmpfs  rw
OPCODE(18) | fd(-100) | path(./file0)
